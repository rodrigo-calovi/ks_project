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



type type_state is (INICIO, DECODE, ULA, PC);

signal estado_atual : type_state;
signal prox_estado : type_state;



begin



FLIP_FLOP : process(clk)                                                -- processo FLIP_FLOP

    begin
    
        if (clk'event AND rising_edge(clk)) then
        
            if (rst_n = '0') then
                estado_atual <= INICIO;
                
            else
                estado_atual <= prox_estado;
            
            end if;
            
        end if;
        
end process FLIP_FLOP;




CALCULA_ESTADO : process(estado_atual)                             -- CALCULA_ESTADO

    begin
        
        case estado_atual is
	       
	       when INICIO =>
	           
                ir_enable <= '1';
                write_reg_enable <= '0';
                c_sel <= '0';
                flags_reg_enable <= '0';
                branch <= '0';
                pc_enable <= '0';
                addr_sel <= '0';
                ram_write_enable <= '0';
                halt <= '0';                
                prox_estado <= DECODE;
            
               
            when DECODE =>
            
                ir_enable <= '0';
                
                case decoded_instruction is
                
                    when I_ADD =>
                    
                        operation <= "01";
                        prox_estado <= ULA;
                    
                    
                    when I_SUB =>
                    
                        operation <= "10";
                        prox_estado <= ULA;


                    when I_AND =>  
                                      
                        operation <= "11";
                        prox_estado <= ULA;
                        
                        
                    when I_OR =>
                    
                        operation <= "00";
                        prox_estado <= ULA;
                        
                    
                    when I_LOAD =>
                        
                        addr_sel <= '1';
                        c_sel <= '1';
                        write_reg_enable <= '1';                        
                        prox_estado <= PC;
                        
                        
                    when I_STORE =>
                    
                        addr_sel <= '1';    
                        ram_write_enable <= '1';                        
                        prox_estado <= PC;
                            
                            
                    when I_MOVE =>
                        
                        operation <= "00";
                        write_reg_enable <= '1';
                        prox_estado <= PC;
                        
                        
                    when I_BRANCH =>
                        
                        branch <= '1';
                        prox_estado <= PC;

                    
                    when I_BZERO =>
                    
                        if (zero_op = '1') then
                            
                            branch <= '1';                                                       
                            prox_estado <= PC;  
                        
                        else
                                                    
                            prox_estado <= PC;
                        
                        end if;
                        
                        
                    when I_BNEG =>
                        
                        if (neg_op = '1') then
                            
                            branch <= '1';                                                       
                            prox_estado <= PC;  
                        
                        else
                                                    
                            prox_estado <= PC;
                        
                        end if;
                    
                    
                    when I_NOP =>
                    
                            prox_estado <= PC;
                            
                    
                    when others =>
                            halt <= '1';
                        
                end case;
                
                
                when ULA =>
                    
                    flags_reg_enable <= '1';              
                    write_reg_enable <= '1';          
                    prox_estado <= PC;                   
                
                
                when PC =>
                    
                    pc_enable <= '1';
                    addr_sel <= '0';
                    prox_estado <= INICIO;
                     
                    
                    
                
        end case;

end process CALCULA_ESTADO;



end rtl;

