library IEEE;
use IEEE.std_logic_1164.all;

entity Shift_REG_R_8bits is 
generic (size : integer := 8);
port(
data_in : in std_logic_vector (size-1 downto 0);
in_load , in_clk , in_shift : in std_logic;
data_out 	: out std_logic_vector (size-1 downto 0)
);
end Shift_REG_R_8bits;

architecture behave of Shift_REG_R_8bits is

signal reg_signal: std_logic_vector (size-1 downto 0);
begin

process (in_clk , in_load , in_shift)
	begin
	if rising_edge(in_clk) then
		if in_load='1' then
		reg_signal<= data_in;		
		elsif in_shift = '1' then
		reg_signal <= '0'& reg_signal(size-1 downto 1); 
		end if; 
	end if;
end process;

data_out <= reg_signal;

end architecture;

