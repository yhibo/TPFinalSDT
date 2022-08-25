----------------------------------------------------------------------------------
-- Institution: Instituto Balseiro
-- Deve:        Guillermo Guichal
--
-- Design Name: TP1
-- Module Name:
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: Ejemplos básicos de diseño VHDL
--
-- Dependencies: None.
--
-- Revision: 2022-02-17.01
-- Additional Comments:
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tp2_no_pipeline is
  generic (
    DATA_WIDTH : integer := 16
  );
  port (
    clk_i, srst_i        : in std_logic;
    selop1_i, selop2_i   : in std_logic_vector(1 downto 0);
    selout1_i, selout2_i : in std_logic_vector(1 downto 0);
    a_i, b_i, c_i        : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    x_o                  : out std_logic_vector(2 * (DATA_WIDTH + 1) - 1 downto 0));
end tp2_no_pipeline;

architecture rtl of tp2_no_pipeline is
  signal selop1_r, selop2_r, selout1_r, selout2_r : std_logic_vector(1 downto 0);
  signal a_r, b_r, c_r : signed(DATA_WIDTH - 1 downto 0);
  signal operando1, operando2 : signed(DATA_WIDTH downto 0);
  signal suma, resta, abs1, abs2 : signed(DATA_WIDTH downto 0);
  signal x1, x2 : signed(DATA_WIDTH downto 0);
  signal x : signed(2 * (DATA_WIDTH + 1) - 1 downto 0);
begin

  -- Registro entradas como buena practica (y para poder ver resultados de timing)
  process (clk_i)
  begin
    if rising_edge(clk_i) then
      if srst_i = '1' then
        selop1_r <= (others => '0');
        selop2_r <= (others => '0');
        selout1_r <= (others => '0');
        selout2_r <= (others => '0');
      else
        selop1_r <= selop1_i;
        selop2_r <= selop2_i;
        selout1_r <= selout1_i;
        selout2_r <= selout2_i;
      end if;
    end if;
  end process;

  process (clk_i)
  begin
    if rising_edge(clk_i) then
      if srst_i = '1' then
        a_r <= (others => '0');
        b_r <= (others => '0');
        c_r <= (others => '0');
      else
        a_r <= signed(a_i);
        b_r <= signed(b_i);
        c_r <= signed(c_i);
      end if;
    end if;
  end process;

  -- Proceso combinacional
  process (selop1_r, selop2_r, a_r, b_r, c_r)
  begin
    case selop1_r is
      when "00" => operando1 <= resize(a_r, operando1'length); -- REsize sobre signed implementa sign extension
      when "01" => operando1 <= resize(b_r, operando1'length);
      when "10" => operando1 <= resize(c_r, operando1'length);
      when others => operando1 <= (others => '0');
    end case;

    case selop2_r is
      when "00" => operando2 <= resize(a_r, operando2'length);
      when "01" => operando2 <= resize(b_r, operando2'length);
      when "10" => operando2 <= resize(c_r, operando2'length);
      when others => operando2 <= (others => '0');
    end case;
  end process;

  suma <= operando1 + operando2;
  resta <= operando1 - operando2;
  abs1 <= abs(operando1);
  abs2 <= abs(operando2);

  with selout1_r select x1 <=
    suma when "00",
    resta when "01",
    abs1 when "10",
    abs2 when others;

  with selout2_r select x2 <=
    suma when "00",
    resta when "01",
    abs1 when "10",
    abs2 when others;

  x <= x1 * x2;

  -- Registro salidas como buena practica (y para poder ver resultados de timing)
  process (clk_i)
  begin
    if rising_edge(clk_i) then
      if srst_i = '1' then
        x_o <= (others => '0');
      else
        x_o <= std_logic_vector(x);
      end if;
    end if;
  end process;

end rtl;
