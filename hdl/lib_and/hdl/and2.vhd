--------------------------------------------------------------------------------
--
-- Filename          : and2.vhd
-- VHDL Entity       : and2
--      Architecture : rtl
--      Library      : lib_and
--
-- Created:
--          by - Jordan Woods
--          at - Sat, 07 Dec 2024
--
--------------------------------------------------------------------------------
-- make-hdl © 2025 by Jordan Woods is licensed under CC BY-NC-SA 4.0. --
-- To view a copy of this license, visit                              --
-- https://creativecommons.org/licenses/by-nc-sa/4.0/                 --
--------------------------------------------------------------------------------
-- Purpose      : Simple and module to prove out the makefiles.
--
--------------------------------------------------------------------------------
-- History:
-- Date               Author         Comment
-- Sat, 07 Dec 2024   Jordan Woods   Initial design
--
--------------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity and2 is
   generic (
      G_WIDTH : integer := 4
   );
   port (
      -- Inputs
      a : in std_logic_vector(G_WIDTH-1 downto 0);
      b : in std_logic_vector(G_WIDTH-1 downto 0);
      -- Outputs
      c : out std_logic_vector(G_WIDTH-1 downto 0)
   );
end entity and2;

architecture rtl of and2 is
begin
   c <= a and b;
end architecture rtl;

