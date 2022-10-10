library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Sequential_Multiplier_8bits is

generic (n : integer := 8);
port(
clk , rst , start : in std_logic;
A , B : in std_logic_vector ((n-1) downto 0);
done : out std_logic;
P : out std_logic_vector ((2*n-1)downto 0)
);
end entity;

Architecture behave of Sequential_Multiplier_8bits is


-- signals
-------------
--signals for the multiplicand 
-- load input for the multiplicand REG
signal shift_multiplicand : std_logic; 
-- in this case it will have the value of B
signal Multiplicand : std_logic_vector ((n-1) downto 0);
--signals for the multipier 
-- multiplier(0) is the indicator it the mutilpilicand is the same or '0's
signal multiplier : std_logic_vector ((n-1)downto 0);
--load_multiplier , shift_multiplier
signal load_multiplier , shift_multiplier : std_logic;
-- signals for the full adder
--inputs of the adder
signal adder_x, adder_y : std_logic_vector ((n-1)downto 0);
signal adder_out : std_logic_vector (n downto 0);
--signals for the output of the adder and the final stage
signal product : std_logic_vector ((2*n-1)downto 0);
signal reset_product , load_product , shift_product : std_logic;
------------------------------------------------------------------------------------------------
-- components
---------------
-- register (used for loading B)
Component REG_8bits is 
generic (size : integer := 8);
port(
data_in : in std_logic_vector (size-1 downto 0);
in_load , in_clk : in std_logic;
data_out 	: out std_logic_vector (size-1 downto 0)
);
end component;
-- shift right register 8 bits (used for loading A)
component Shift_REG_R_8bits is 
generic (size : integer := 8);
port(
data_in : in std_logic_vector (size-1 downto 0);
in_load , in_clk , in_shift : in std_logic;
data_out 	: out std_logic_vector (size-1 downto 0)
);
end component;
-- Full adder 8 bits
component Full_Add_8bits is 
generic (size : integer := 8 );
port(
x,y : in std_logic_vector ((size-1) downto 0);
s	: out std_logic_vector (size downto 0)
);
end component;
-- shift right register 16 bits (used for loading A)
component Shift_REG_R_16bits is 
generic (size : integer := 8);
port(
data_in : in std_logic_vector (size downto 0);
in_load , in_clk , in_shift , in_rst : in std_logic;
data_out 	: out std_logic_vector ((2*size-1) downto 0)
);
end component;
--system controller
component system_controller is
port (

in_clk : in std_logic ;
in_rst, in_start : in std_logic := '0' ;

out_load_multiplier, out_shift_multiplier : out std_logic;
out_shift_multiplicand : out std_logic;  
out_reset_product ,out_load_product, out_shift_product : out std_logic;
out_done : out std_logic 
);
end component;

-- start behave
begin
-- port mapping phase
From_B_to_multiplicand : REG_8bits
port map (data_in => B , in_load => shift_multiplicand , in_clk => clk , data_out => Multiplicand);
-----------------------------------------------------------
From_A_to_multiplier : Shift_REG_R_8bits
port map (data_in => A , in_load => load_multiplier , in_clk => clk , in_shift => shift_multiplier , data_out => multiplier);
-----------------------------------------------------------
From_OutputOfAND_to_FullAdder : Full_Add_8bits
port map (x=> adder_x ,y=> adder_y ,s=> adder_out);
--from the Adder to the product
From_FullAdder_to_product : Shift_REG_R_16bits
port map( data_in => adder_out , in_load => load_product , in_clk => clk , in_shift => shift_product , in_rst => reset_product , data_out => product);
-- system controller
sys_con : system_controller
port map (in_clk => clk , in_rst => rst , in_start => start ,
		  out_load_multiplier =>load_multiplier , out_shift_multiplier=> shift_multiplier,
		  out_shift_multiplicand => shift_multiplicand,
		  out_reset_product => reset_product ,out_load_product => load_product, out_shift_product => shift_product ,
		  out_done => done );
------------------------------------------------------------------
adder_y <= product(15 downto 8);
------------------------------------------------------------
Anding:process(load_multiplier , shift_multiplicand)
	begin		
		for i in 0 to 7 loop
			adder_x(i) <= multiplicand(i) and multiplier(0);
		end loop;
	end process;
--------------------------------------------------------------
p <= product;
end behave;