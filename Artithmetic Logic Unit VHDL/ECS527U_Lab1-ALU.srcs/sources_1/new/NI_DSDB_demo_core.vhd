----------------------------------------------------------------------------------
-- Company: Queen Mary University of London
-- Engineer: Matthew Tang
-- 
-- Create Date: 13.02.2019 11:12:03
-- Design Name: 
-- Module Name: NI_DSDB_demo_core - Behavioral
-- Project Name: ECS527U Lab 1 - ALU
-- Target Devices: NI DSDB Board
-- Tool Versions: Vivado 2017.03
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NI_DSDB_demo_core is
    port (
        sw: in std_logic_vector(7 downto 0);
        led: out std_logic_vector(7 downto 0);
        btn: in std_logic_vector(3 downto 0);
        CLK: in std_logic;
        ss3: out std_logic_vector(3 downto 0);
        ss2: out std_logic_vector(3 downto 0);
        ss1: out std_logic_vector(3 downto 0);
        ss0: out std_logic_vector(3 downto 0)
    );
end NI_DSDB_demo_core;

architecture Behavioral of NI_DSDB_demo_core is
    signal A, B, Y1, Y2, Y, CO1, CO2: std_logic_vector(3 downto 0);
    signal Cin, Cout, En1, En2: std_logic;
    signal Fsel: std_logic_vector(2 downto 0);
    signal CI: std_logic_vector(4 downto 0);
    component ALUSlice2 is
    port (
        A, B, Cin: in std_logic;
        En: in std_logic;
        Fsel: in std_logic_vector(1 downto 0);
        Cout, Y: out std_logic
    );
    end component;
    component ALUSlice1 is
    port (
        A, B, Cin: in std_logic;
        En: in std_logic;
        Fsel: in std_logic_vector(1 downto 0);
        Cout, Y: out std_logic
    );
    end component;
begin    
    -- connect the inputs
    A <= sw(7 downto 4);
    B <= sw(3 downto 0);
    Cin <= btn(3);
    Fsel <= btn(2 downto 0);
    -- connect the outpus
    led(3 downto 0) <= Y;
    led(4) <= Cout;
    led(7 downto 5) <= (others => '0'); -- not used
    ss3 <= A; -- mirror A
    ss2 <= B; -- mirror B
    ss1 <= (others => '0'); -- not used now
    ss0 <= Y; -- output from ALU
    
    ALUSliceGen: for i in 3 downto 0 generate
        U_Slice1: ALUSlice1 port map (A=>A(i), B=>B(i), Cin=>CI(i), En=>En1, Fsel=>Fsel(1 downto 0), Cout=>CO1(i), Y=>Y1(i));
        U_Slice2: ALUSlice2 port map (A=>A(i), B=>B(i), Cin=>CI(i), En=>En2, Fsel=>Fsel(1 downto 0), Cout=>CO2(i), Y=>Y2(i));
        -- logic AND to join results from Slice1 and Slice2
        Y(i) <= Y1(i) and Y2(i); 
        CI(i + 1) <= CO1(i) and CO2(i);
    end generate;
    -- choose the slice based on MSB of Fsel
    En1 <= not Fsel(2);
    En2 <= Fsel(2);
    -- generate the correct carry in (bit 0) on different cases
    with Fsel select
    CI(0) <= '1'        when "010",
             Cin        when "011",
             not Cin    when "111",
             '0'        when others;
    Cout <= CI(4); -- carry from the MSB slice
end Behavioral;
