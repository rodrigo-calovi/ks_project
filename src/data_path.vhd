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
-- Para avaliacao de Sistemas Digitais:
-- Luana Santana, Michele Liese e Rodrigo Calovi
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.k_and_s_pkg.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

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
    
    -- receptores de endereco
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
    
    -- saida do MUX (RAM ou ULA)
    signal bus_C : std_logic_vector (15 downto 0);
    
    -- saida da ULA para bus_c   
    signal ula_out : std_logic_vector (15 downto 0);
    
    -- saida da ULA para flag_reg
    signal zero_op_flag : std_logic;
    signal neg_op_flag : std_logic;
    signal unsigned_overflow_flag : std_logic;
    signal signed_overflow_flag : std_logic;
    
    -- entrada do PC
    signal pc_in : std_logic_vector (4 downto 0);

    -- saida do PC
    signal program_counter : std_logic_vector (4 downto 0);

begin



IR : process (clk)                                          -- processo IR
    
    begin
    
        if (ir_enable = '1') then                           -- verifica se pode passar a instrucao ou nao, depende do ir_enable
        instruction <= data_in;                             -- passa a instrucao data_in para instruction
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
    
        case  a_addr is                                     -- verifica o endereco que estao em a_addr
            when "00" => bus_a <= reg_0;                    -- bus_a recebe o que esta em reg_0
            when "01" => bus_a <= reg_1;                    -- bus_a recebe o que esta em reg_1
            when "10" => bus_a <= reg_2;                    -- bus_a recebe o que esta em reg_2
            when others => bus_a <= reg_3;                  -- bus_a recebe o que esta em reg_3
        end case;
       
        case  b_addr is                                     -- verifica o endereco que esta em b_addr
            when "00" => bus_b <= reg_0;                    -- bus_b recebe o que esta em reg_0
            when "01" => bus_b <= reg_1;                    -- bus_b recebe o que esta em reg_1
            when "10" => bus_b <= reg_2;                    -- bus_b recebe o que esta em reg_2
            when others => bus_b <= reg_3;                  -- bus_b recebe o que esta em reg_3
        end case;
       
        if (write_reg_enable = '1') then                    -- verifica se o write_reg_enable esta¡ habilitado para acessar os registradores 
       
            case  c_addr is                                 -- verifica o endereco que esta em c_addr
                when "00" => reg_0 <= bus_c;                -- reg_0 recebe o que esta em bus_c
                when "01" => reg_1 <= bus_c;                -- reg_1 recebe o que esta em bus_c
                when "10" => reg_2 <= bus_c;                -- reg_2 recebe o que esta em bus_c
                when others => reg_3 <= bus_c;              -- reg_3 recebe o que esta em bus_c
            end case;   
       
       end if;
       
       data_out <= bus_a;                                   -- data_out recebe o que esta em bus_a
    
end process BANCO_DE_REGISTRADORES;
    

    
    
ULA : process (bus_a, bus_b, operation)                     -- processo ULA 
        
    begin
        
        if(operation = "00") then                           -- SOMA
            ula_out <= bus_a + bus_b;                       -- ula_out recebe a soma de bus_a com bus_b
            
            if (bus_a(15) = '0' AND bus_b(15) = '0') AND ula_out(15) = '1' then
                signed_overflow_flag <= '1';                -- signed_overflow_flag recebe 1
                
            elsif (bus_a(15) = '1' AND bus_b(15) = '1') AND ula_out(15) = '0' then
                signed_overflow_flag <= '1';                -- signed_overflow_flag recebe 1
                
            elsif (bus_a(15) = '0' AND bus_b(15) = '1') AND (bus_a >= (NOT bus_b) - "1") then
               unsigned_overflow_flag <= '1';               -- unsigned_overflow_flag recebe 1
               
            elsif (bus_a(15) = '1' AND bus_b(15) = '0') AND (bus_b >= (NOT bus_a) - "1") then
               unsigned_overflow_flag <= '1';               -- unsigned_overflow_flag recebe 1
                
            elsif (bus_a(15)='1' and bus_b(15)='1') then
               unsigned_overflow_flag <= '1';               -- unsigned_overflow_flag recebe 1
               
            end if;
            
               
        elsif(operation = "01") then                        -- SUB
            ula_out <= bus_b - bus_a;                       -- ula_out recebe a subtracao de bus_a com bus_b
            
            if(bus_a(15) = '0' AND bus_b(15) = '1') AND ula_out(15) = '1' then 
            signed_overflow_flag <= '1';                    -- signed_overflow_flag recebe 1
                
            elsif (bus_a(15) = '1' AND bus_b(15) = '0') AND ula_out(15) = '0' then
            signed_overflow_flag <= '1';                    -- signed_overflow_flag recebe 1
            
            elsif (bus_a(15) = '0' and bus_b(15) = '0') and (bus_a >= bus_b) then
            unsigned_overflow_flag <= '1';                  -- unsigned_overflow_flag recebe 1
            
            elsif (bus_a(15) = '1' and bus_b(15) = '1') and ((not bus_a) - "1" <= (not bus_b)-1) then
            unsigned_overflow_flag <= '1';                  -- unsigned_overflow_flag recebe 1
            
            elsif (bus_a(15)='1' and bus_b(15)='0') then
            unsigned_overflow_flag <= '1';                  -- unsigned_overflow_flag recebe 1
            
            end if;
            
            
        elsif(operation = "10") then                        -- AND    
            ula_out <= bus_a AND bus_b;                     -- ula_out recebe a and de bus_a com bus_b
        
        
        else                                                -- OR
            ula_out <= bus_a OR bus_b;                      -- ula_out recebe a or de bus_a com bus_b 
        
        end if;

end process ULA;



C_SEL_MUX : process (c_sel, data_in, ula_out)               -- processo C_SEL_MUX
       
    begin
        
        if (c_sel='0') then                                 -- verifica se c_sel esta habilitado para a RAM
            bus_c <= data_in;                               -- bus_c recebe data_in

        else
            bus_c <= ula_out;                               -- bus_c recebe ula_out
         
        end if;
        
end process C_SEL_MUX;



zero_op_flag <= '1' when ula_out = X"0000" else '0';
neg_op_flag <= '1' when ula_out(15) = '1';
    
    
    
FLAG_ENABLE : process (clk)

    begin
    
        zero_op <= '0';
        neg_op <= '0';
        signed_overflow <= '0';
        unsigned_overflow <= '0';
        
        if (flags_reg_enable = '1') then                    -- verifica se o flags_reg_enable esta habilitado
            zero_op <= zero_op_flag;                        -- zero_op recebe de zero_op_flag
            neg_op <= neg_op_flag;                          -- neg_op recebe de neg_op_flag
            signed_overflow <= signed_overflow_flag;        -- signed_overflow recebe de signed_overflow_flag
            unsigned_overflow <= unsigned_overflow_flag;    -- unsigned_overflow recebe de unsigned_overflow_flag
        end if;
    
end process FLAG_ENABLE;



BRANCH_MUX : process (branch, program_counter, mem_addr)    -- processo BRANCH_MUX
    
    begin
        if (branch = '0') then                              -- verifica se o branch eh 0
            pc_in <= program_counter + 1;                   -- pc_in recebe program_counter somando 1
            
        else
            pc_in <= mem_addr;                              -- pc_in recebe mem_addr
            
        end if;
        
end process BRANCH_MUX;



PC : process (clk)                                          -- processo PC
    
    begin
        
        if (rst_n = '0') then                               -- verifica se o rst_n voltou a ser 0
            program_counter <= "00000";                     -- program_counter recebe 00000 e volta ao inicio
            
        elsif (pc_enable = '1') then                        -- verifica se o pc_enable esta habilitado
            program_counter <= pc_in;                       -- program_counter recebe pc_in
            
        end if;
        
end process PC;



ADDR_SEL_MUX : process (addr_sel, program_counter, mem_addr)-- processo ADDR_SEL_MUX 
    
    begin
        
        if (addr_sel = '0') then                            -- verifica se addr_sel eh 0
            ram_addr <= mem_addr;                           -- ram_addr recebe mem_addr
        
        else
            ram_addr <= program_counter;                    -- ram_addr recebe program_counter
        
        end if;
        
end process ADDR_SEL_MUX;

end rtl;
