LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use ieee.numeric_std.all; 
------------------------------------------------------------------
entity top is
	generic ( n : positive := 8 ); 
	port( rst_i, clk_i, repeat_i : in std_logic;
		  upperBound_i : in std_logic_vector(n-1 downto 0);
		  count_o : out std_logic_vector(n-1 downto 0);
		  busy_o : out std_logic);
end top;
------------------------------------------------------------------
architecture arc_sys of top is
	
	SIGNAL cnt_slow_signal, cnt_fast_signal, temp : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	SIGNAL control_fast_signal, control_slow_signal : STD_LOGIC_VECTOR (1 DOWNTO 0);	
					-- 00-> keep going  01-->restart  11/10-->freeze


	
begin
	----------------------------------------------------------------
	----------------------- fast counter process -------------------
	----------------------------------------------------------------
	proc1 : process(clk_i,rst_i)
	VARIABLE cnt_fast_var : unsigned(n-1 downto 0) := (others => '0');
	begin	
		IF (rst_i = '1') THEN
			cnt_fast_var := (OTHERS => '0');
			cnt_fast_signal <= (OTHERS => '0');	--vector of zeros

		ELSIF ((rising_edge(clk_i)) and (control_fast_signal = "00")) THEN	--raise
			cnt_fast_var := cnt_fast_var+1;
			cnt_fast_signal <=std_logic_vector(cnt_fast_var);

		ELSIF ((rising_edge(clk_i)) and (control_fast_signal = "01")) THEN	--reset round
			cnt_fast_var := (OTHERS => '0');
			cnt_fast_signal <= (OTHERS => '0');	--vector of zeros

	

--VARIABLE temp: std_LOGIC_VECTOR (7 DOWNTO 0)   temp(7) := '1';    temp := "00101010";  temp +1;

		END IF;		--Else do nothing is when we want to freeze the process whenever repeat is down
		
		
		
		
		
		
	end process;
	----------------------------------------------------------------
	---------------------- slow counter process --------------------
	----------------------------------------------------------------
	proc2 : process(clk_i,rst_i)
	VARIABLE cnt_slow_var : unsigned(n-1 downto 0) := (others => '0');      
	begin
		IF (rst_i = '1') THEN
			cnt_slow_var := (OTHERS => '0');
			cnt_slow_signal <= (OTHERS => '0');	--vector of zeros

		ELSIF (rising_edge(clk_i) and control_slow_signal = "00") THEN		--raising by 1
		cnt_slow_var := cnt_slow_var+1;		
		

		ELSIF (rising_edge(clk_i) and control_slow_signal = "01") THEN		--return to zero
			cnt_slow_var := (OTHERS => '0');
			cnt_slow_signal <= (OTHERS => '0');	--vector of zeros
		
		END IF;									--otherwise we wait 

		cnt_slow_signal <= std_logic_vector(cnt_slow_var);
		
		
	end process;
	---------------------------------------------------------------
	--------------------- combinational part ----------------------
	---------------------------------------------------------------
	temp <= upperBound_i;
	count_o <= cnt_fast_signal;
	control_fast_signal <= "00" WHEN cnt_slow_signal > cnt_fast_signal    --need to raise by 1
	ELSE "11" WHEN (cnt_fast_signal >= temp and repeat_i ='0')	      --freeze mode since repeat is down
	ELSE "01";							      --reset me

	control_slow_signal <="11" WHEN ((cnt_slow_signal > cnt_fast_signal) or (cnt_fast_signal >= temp and repeat_i ='0')   ) 	--freeze mode till fast clock will reach me
	ELSE "01" WHEN cnt_slow_signal = upperBound_i				--reset since we are at upper
	ELSE "00" WHEN upperBound_i > cnt_slow_signal;				--raise by 1

	

	busy_o <= '0' WHEN (cnt_fast_signal >= temp and repeat_i ='0' and cnt_fast_signal >= cnt_slow_signal)             --we finished and at busy = '0' only when fast reach upperbound
	ELSE '1';
	
	



	
	
	----------------------------------------------------------------
end arc_sys;







