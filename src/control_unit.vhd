----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineer: Joao Leonardo Fragoso
-- 
-- Create Date:    19:08:01 06/26/2012 
-- Design Name:    K and S modeling
-- Module Name:    control_unit - rtl 
-- Description:    RTL Code for K and S control unit
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
--          0.02 - moving to Vivado 2017.3
-- Additional Comments: 
-- Para avaliação de Sistemas Digitais:
-- Luana Santana, Michele Liese e Rodrigo Calovi
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.k_and_s_pkg.all;

entity control_unit is
  port (
    rst_n               : in  std_logic;
    clk                 : in  std_logic;
    branch              : out std_logic;
    pc_enable           : out std_logic;
    ir_enable           : out std_logic;
    write_reg_enable    : out std_logic;
    addr_sel            : out std_logic;
    c_sel               : out std_logic;
    operation           : out std_logic_vector (1 downto 0);
    flags_reg_enable    : out std_logic;
    decoded_instruction : in  decoded_instruction_type;
    zero_op             : in  std_logic;
    neg_op              : in  std_logic;
    unsigned_overflow   : in  std_logic;
    signed_overflow     : in  std_logic;
    ram_write_enable    : out std_logic;
    halt                : out std_logic
    );
end control_unit;

architecture rtl of control_unit is
-- signal added to test environment... remove this
signal counter : std_logic_vector(7 downto 0);
begin

--process to test environment ... remove this
    main: process(clk, rst_n)
    begin
        if (rst_n = '0') then
            counter <= (others => '0');
        elsif (clk'event and clk='1') then
            counter <= counter + 1;
        end if;
    end process main;
    halt <= '1' when counter = x"5f" else '0';
-- remove until here....
end rtl;

