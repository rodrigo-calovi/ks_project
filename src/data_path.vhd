----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineer: Joao Leonardo Fragoso
-- 
-- Create Date:    19:04:44 06/26/2012 
-- Design Name:    K and S Modeling
-- Module Name:    data_path - rtl 
-- Description:    RTL Code for the K and S datapath
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
--          0.02 - Moving Vivado 2017.3
-- Additional Comments: 
-- Para avaliação de Sistemas Digitais:
-- Luana Santana, Michele Liese e Rodrigo Calovi
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.k_and_s_pkg.all;

entity data_path is
  port (
    rst_n               : in  std_logic;
    clk                 : in  std_logic;
    branch              : in  std_logic;
    pc_enable           : in  std_logic;
    ir_enable           : in  std_logic;
    addr_sel            : in  std_logic;
    c_sel               : in  std_logic;
    operation           : in  std_logic_vector ( 1 downto 0);
    write_reg_enable    : in  std_logic;
    flags_reg_enable    : in  std_logic;
    decoded_instruction : out decoded_instruction_type;
    zero_op             : out std_logic;
    neg_op              : out std_logic;
    unsigned_overflow   : out std_logic;
    signed_overflow     : out std_logic;
    ram_addr            : out std_logic_vector ( 4 downto 0);
    data_out            : out std_logic_vector (15 downto 0);
    data_in             : in  std_logic_vector (15 downto 0)
  );
end data_path;



architecture rtl of data_path is

    signal instruction : std_logic_vector (15 downto 0);
    signal a_addr : std_logic_vector (1 downto 0); 
    signal b_addr : std_logic_vector (1 downto 0);
    signal c_addr : std_logic_vector (1 downto 0);
    signal mem_addr : std_logic_vector (4 downto 0);

    -- registradores R0, R1, R2 e R3
    signal reg_0 : std_logic_vector (15 downto 0);
    signal reg_1 : std_logic_vector (15 downto 0);
    signal reg_2 : std_logic_vector (15 downto 0);
    signal reg_3 : std_logic_vector (15 downto 0);

    -- entrada da ULA
    signal bus_a : std_logic_vector (15 downto 0);
    signal bus_b : std_logic_vector (15 downto 0);
    
    -- saída do MUX (RAM ou ULA)
    signal bus_C : std_logic_vector (15 downto 0);
    
    -- saida dA ULA    
    signal ula_out : std_logic_vector (15 downto 0);



begin



IR : process (clk)                                          -- processo IR
    begin
        if (ir_enable = '1') then                           -- verifica se pode passar a instrução ou não, depende do ir_enable
        instruction <= data_in;                             -- passa a instrução data_in para instruction
        end if;
    end process IR;
    


DECODE : process (instruction)                              -- processo DECODE
    begin
        a_addr <= "00";                                     -- VERIFICAR
        b_addr <= "00";                                     -- VERIFICAR
        c_addr <= "00";                                     -- VERIFICAR
        mem_addr <= "00000";                                -- VERIFICAR
        decoded_instruction <= I_NOP;                       -- VERIFICAR
        
        
        -----------         Other Instructions:         -----------
        
        if(instruction(15 downto 8) = "11111111") then      -- HALT
            decoded_instruction <= I_HALT;                  -- decoded_instruction recebe I_HALT
            
            
        -----------  Arithmetic and Logic Instructions:  -----------
        
        elsif(instruction(15 downto 8) = "10100001") then   -- ADD
            decoded_instruction <= I_ADD;                   -- decoded_instruction recebe I_ADD
            b_addr <= instruction(1 downto 0);              -- b_addr recebe os bits 1 e 0
            a_addr <= instruction(3 downto 2);              -- a_addr recebe os bits 3 e 2
            c_addr <= instruction(5 downto 4);              -- c_addr recebe os bits 5 e 4
 
        elsif(instruction(15 downto 8) = "10100010") then   -- SUB
            decoded_instruction <= I_SUB;                   -- decoded_instruction recebe I_SUB
            b_addr <= instruction(1 downto 0);              -- b_addr recebe os bits 1 e 0
            a_addr <= instruction(3 downto 2);              -- a_addr recebe os bits 3 e 2
            c_addr <= instruction(5 downto 4);              -- c_addr recebe os bits 5 e 4
    
        elsif(instruction(15 downto 8) = "10100011") then   -- AND
            decoded_instruction <= I_AND;                   -- decoded_instruction recebe I_AND
            b_addr <= instruction(1 downto 0);              -- b_addr recebe os bits 1 e 0
            a_addr <= instruction(3 downto 2);              -- a_addr recebe os bits 3 e 2
            c_addr <= instruction(5 downto 4);              -- c_addr recebe os bits 5 e 4
            
        elsif(instruction(15 downto 8) = "10100100") then   -- OR
            decoded_instruction <= I_OR;                    -- decoded_instruction recebe I_OR
            b_addr <= instruction(1 downto 0);              -- b_addr recebe os bits 1 e 0
            a_addr <= instruction(3 downto 2);              -- a_addr recebe os bits 3 e 2
            c_addr <= instruction(5 downto 4);              -- c_addr recebe os bits 5 e 4
            
         
        -----------     Data Movement Instructions:     -----------
            
        elsif(instruction(15 downto 8) = "10000001") then   -- LOAD
            decoded_instruction <= I_LOAD;                  -- decoded_instruction recebe I_LOAD
            c_addr <= instruction(6 downto 5);              -- c_addr recebe os bits 6 e 5
            mem_addr <= instruction(4 downto 0);            -- mem_addr recebe os bits 4, 3, 2, 1 e 0

        elsif(instruction(15 downto 8) = "10000010") then   -- STORE
            decoded_instruction <= I_STORE;                 -- decoded_instruction recebe I_STORE
            c_addr <= instruction(6 downto 5);              -- c_addr recebe os bits 6 e 5
            mem_addr <= instruction(4 downto 0);            -- mem_addr recebe os bits 4, 3, 2, 1 e 0

         elsif(instruction(15 downto 8) = "10010001") then  -- MOVE
            decoded_instruction <= I_MOVE;                  -- decoded_instruction recebe I_MOVE
            a_addr <= instruction(1 downto 0);              -- a_addr recebe os bits 1 e 0
            b_addr <= instruction(1 downto 0);              -- b_addr recebe os bits 1 e 0
            c_addr <= instruction(3 downto 2);              -- c_addr recebe os bits 3 e 2
            
            
        -----------       Branching Instructions:       -----------
        
        elsif(instruction(15 downto 8) = "00000001") then   -- BRANCH
            decoded_instruction <= I_BRANCH;                -- decoded_instruction recebe I_BRANCH
            mem_addr <= instruction(4 downto 0);            -- mem_addr recebe os bits 4, 3, 2, 1 e 0
            
        elsif(instruction(15 downto 8) = "00000010") then   -- BZERO
            decoded_instruction <= I_BZERO;                 -- decoded_instruction recebe I_BZERO
            mem_addr <= instruction(4 downto 0);            -- mem_addr recebe os bits 4, 3, 2, 1 e 0
            
        elsif(instruction(15 downto 8) = "00000011") then   -- BNEG
            decoded_instruction <= I_BNEG;                  -- decoded_instruction recebe I_BZERO
            mem_addr <= instruction(4 downto 0);            -- mem_addr recebe os bits 4, 3, 2, 1 e 0


        -----------         Other Instructions:         -----------

        else                                                -- NOP
            decoded_instruction <= I_NOP;                   -- decoded_instruction recebe I_NOP
                    
        end if;

    end process DECODE;
    
    
    BANCO_DE_REGISTRADORES : process (clk)                      -- processo BANCO_DE_REGISTRADORES

    begin
    
        case  a_addr is                                     -- verifica o endereço que está em a_addr
            when "00" => bus_a <= reg_0;                    -- bus_a recebe o que está em reg_0
            when "01" => bus_a <= reg_1;                    -- bus_a recebe o que está em reg_1
            when "10" => bus_a <= reg_2;                    -- bus_a recebe o que está em reg_2
            when others => bus_a <= reg_3;                  -- bus_a recebe o que está em reg_3
        end case;
       
        case  b_addr is                                     -- verifica o endereço que está em b_addr
            when "00" => bus_b <= reg_0;                    -- bus_b recebe o que está em reg_0
            when "01" => bus_b <= reg_1;                    -- bus_b recebe o que está em reg_1
            when "10" => bus_b <= reg_2;                    -- bus_b recebe o que está em reg_2
            when others => bus_b <= reg_3;                  -- bus_b recebe o que está em reg_3
        end case;
       
        if (write_reg_enable = '1') then                    -- verifica se o write_reg_enable está habilitado para acessar os registradores 
       
            case  c_addr is                                 -- verifica o endereço que está em c_addr
                when "00" => reg_0 <= bus_c;                -- reg_0 recebe o que está em bus_c
                when "01" => reg_1 <= bus_c;                -- reg_1 recebe o que está em bus_c
                when "10" => reg_2 <= bus_c;                -- reg_2 recebe o que está em bus_c
                when others => reg_3 <= bus_c;              -- reg_3 recebe o que está em bus_c
            end case;   
       
       end if;
       
       data_out <= bus_a;                                   -- data_out recebe o que está em bus_a
    
end process BANCO_DE_REGISTRADORES;
    


WRITE_REG_EN : process (c_sel, data_in, ula_out)            -- processo WRITE_REG_EN
       
    begin
        
        if (c_sel='0') then                                 -- verifica se c_sel está habilitado para a RAM
            bus_c <= data_in;                               -- bus_c recebe data_in

        else
            bus_c <= ula_out;                               -- bus_c recebe ula_out
         
        end if;
        
end process WRITE_REG_EN;

    
    
end rtl;

