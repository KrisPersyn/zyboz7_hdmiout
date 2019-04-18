----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2019 03:46:24 PM
-- Design Name: 
-- Module Name: timing - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

--- https://timetoexplore.net/blog/video-timings-vga-720p-1080p


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timing is
Generic (
      refreshrate : boolean := true);  -- change between 30Hz and 60 Hz; not implemented
      
    Port ( CLK : in STD_LOGIC;
           CLKx: out STD_LOGIC;
           CE: in STD_LOGIC;
           RESET: in STD_LOGIC;
    
           video_en : out STD_LOGIC;
           h_sync : out STD_LOGIC;
           v_sync : out STD_LOGIC;
           
           frame_done : out STD_LOGIC;
           
           rgb_in : in STD_LOGIC_VECTOR (23 downto 0);
           rgb_out : out STD_LOGIC_VECTOR (23 downto 0);
           
           x : out STD_LOGIC_VECTOR (10 downto 0);
           y : out STD_LOGIC_VECTOR (10 downto 0));
end timing;

architecture Behavioral of timing is

signal h_done : STD_LOGIC ;
signal v_done : STD_LOGIC ;
signal h_de : STD_LOGIC ;
signal v_de : STD_LOGIC ;


begin
 
 
 CLKx <= CLK;
 
 
Horizontal_sync: process(CLK)
--
variable counth : integer range 0 to 2047 :=0;
variable h_display : integer range 0 to 2047 := 1920;
variable h_total : integer range 0 to 4095 := 2200;
variable h_snc : integer range 0 to 127 := 44;
variable h_fp : integer range 0 to 127 := 88;
variable h_bp : integer range 0 to 255 := 148;
variable h_inscreen : integer range 0 to 255 := h_bp + h_snc;
variable h_outscreen : integer range 0 to 4095 := h_bp + h_snc + h_display;

begin
-- synchronous clock EN and reset if needed 
if  (CLK'event and CLK = '1') then
    if(RESET = '1') then
        counth :=0;
        h_sync <='0';
        h_de <='0';
        h_done <='0';        
        x <= "00000000000";
        
    else
        if(CE ='1') then
            h_done <='0';
            h_sync <='0';  
            h_de <= '0';
             x <= "00000000000";  
            counth := counth  + 1;
            
            if counth = h_total then 
                counth:= 0;
                h_done <='1';
            end if;
            
            if counth >=h_snc then
                h_sync <='1';
            end if ;          
            
             if counth >= h_inscreen  and counth < h_outscreen then
                h_de <='1';
            end if ;
                        
            if (counth >= h_inscreen and counth < h_outscreen) then
           
                    x <= std_logic_vector(to_unsigned(counth - h_inscreen,11));

             end if;
            
        end if;
         
    end if ;
    
end if;

end process;

Vertical_sync: process(CLK)
--
variable countv : integer range 0 to 2047 := 0;
variable v_display : integer range 0 to 2047 := 1080;
variable v_total : integer range 0 to 4095 := 1125 ;
variable v_snc : integer range 0 to 7 := 5;
variable v_fp : integer range 0 to 7 := 4;
variable v_bp : integer range 0 to 63 := 36;
variable v_inscreen : integer range 0 to 255 := v_bp + v_snc;
variable v_outscreen : integer range 0 to 2047 := v_bp + v_snc + v_display;

begin
-- synchronous clock EN and reset if needed 
if  (CLK'event and CLK = '1') then
    if(RESET = '1') then
        countv :=0;
        v_sync <='0';
        v_de <='0';
        v_done <= '0';
        y <= "00000000000";
        
    else
        if(CE ='1') then
            v_sync <='0';
            v_done <= '0';
            v_de <= '0';
            y <= "00000000000";
            
            if h_done = '1' then
                countv := countv  + 1;
            end if;
            
            if countv = v_total then 
                countv:= 0;
                v_done <= '1';
                
            end if;
            
            if countv >=v_snc then
                v_sync <='1';
            end if ;          
            
             if countv >= v_inscreen and countv < v_outscreen then
                v_de <='1';
            end if ;
                        
            if (countv >= v_inscreen and countv < v_outscreen) then
                
                    y <= std_logic_vector(to_unsigned(countv - v_inscreen,11));
                
             end if;
            
        end if;
         
    end if ;
    
end if;

end process;

video_en <= v_de and h_de;
frame_done <= v_done;

rgb_control : process (v_de,h_de)

begin

rgb_out <= "000000000000000000000000";

if (v_de and h_de) = '1' then

rgb_out <= rgb_in;

end if;

end process;



end Behavioral;
