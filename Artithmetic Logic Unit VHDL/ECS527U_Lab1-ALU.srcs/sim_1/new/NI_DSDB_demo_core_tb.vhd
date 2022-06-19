library IEEE;
use IEEE.std_logic_1164.all;

entity NI_DSDB_demo_core_tb is
end NI_DSDB_demo_core_tb;

architecture sim of NI_DSDB_demo_core_tb is
    component NI_DSDB_demo_core is
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
    end component;
    signal sw, led: std_logic_vector(7 downto 0);
    signal CLK: std_logic;
    signal btn, ss3, ss2, ss1, ss0: std_logic_vector(3 downto 0);
begin
    UUT: NI_DSDB_demo_core port map (sw=>sw, led=>led, CLK=>CLK, btn=>btn, ss3=>ss3, ss2=>ss2, ss1=>ss1, ss0=>ss0);
    sim_proc: process
    begin
        sw <= "01100100";
        btn <= "0000";        wait for 100 ns;
        btn <= "0001";        wait for 100 ns;
        btn <= "0010";        wait for 100 ns;
        btn <= "0011";        wait for 100 ns;
        btn <= "0100";        wait for 100 ns;
        btn <= "0101";        wait for 100 ns;
        btn <= "0110";        wait for 100 ns;
        btn <= "0111";        wait for 100 ns;
        btn <= "1010";        wait for 100 ns;
        btn <= "1011";        wait for 100 ns;
        btn <= "1110";        wait for 100 ns;
        btn <= "1111";        wait for 100 ns;
        sw <= "10101100"; -- test case for COUT
        btn <= "0011";
        wait for 100 ns;
        wait;
    end process sim_proc;
end sim;