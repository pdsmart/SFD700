---------------------------------------------------------------------------------------------------------
--
-- Name:            sfd700_Toplevel.vhd
-- Created:         July 2023
-- Author(s):       Philip Smart
-- Description:     SFD700 CPLD Top Level file.
--                                                     
--                  This module contains the top level description between the CPLD pins and the SFD700
--                  device logic.
--
-- Credits:         
-- Copyright:       (c) 2018-23 Philip Smart <philip.smart@net2net.org>
--
-- History:         July 2023 - Initial write.
--
---------------------------------------------------------------------------------------------------------
-- This source file is free software: you can redistribute it and-or modify
-- it under the terms of the GNU General Public License as published
-- by the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This source file is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- along with this program.  If not, see <http:--www.gnu.org-licenses->.
---------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.sfd700_pkg.all;
library altera;
use altera.altera_syn_attributes.all;

entity sfd700 is
    port (
        -- Z80 Address Bus
        Z80_ADDR                  : in    std_logic_vector(15 downto 0);       -- Host Address Bus.
                                                                                                             
        -- Z80 Data Bus                                                                                      
        Z80_DATA                  : inout std_logic_vector(7 downto 0);        -- Host Data Bus.
                                                                                                             
        -- Z80 Control signals.                                                                              
        Z80_M1n                   : in    std_logic;                           -- Host M1n input.
        Z80_RDn                   : in    std_logic;                           -- Host RDn input.
        Z80_WRn                   : in    std_logic;                           -- Host WRn input.
        Z80_IORQn                 : in    std_logic;                           -- Host IORQn input.
        Z80_MREQn                 : in    std_logic;                           -- Host MREQn input.
        Z80_INT                   : out   std_logic;                           -- Host INT output, active high.
        Z80_EXWAITn               : out   std_logic;                           -- Host external Wait output.

        -- Reset.
        Z80_RESETn                : in    std_logic;                           -- Host RESET signal.

        -- Inverted Data to FDC and High Address Bits to ROM/RAM.
        ID                        : inout std_logic_vector(7 downto 0);

        -- ROM/RAM Control Signals.
        ROM_A10                   : out   std_logic;                           -- Flash ROM A10 line - additional address bit and used for MZ-80A DRQ code selection.
        RAM_A10                   : out   std_logic;                           -- RAM A10 line - additional address bit.
        ROM_CSn                   : out   std_logic;                           -- Chip select for Flash ROM.
        RAM_CSn                   : out   std_logic;                           -- Chip select for Flash RAM.
        RSV                       : out   std_logic;                           -- Reserved.

        -- Interface Configuration.
        MODE                      : in    std_logic_vector(2 downto 0);        -- Jumper settings to configure interface behaviour.

        -- Floppy Disk Interface.
        FDCn                      : out   std_logic;                           -- WD1773 chip select.
        INTRQ                     : in    std_logic;                           -- WD1773 Interrupt.
        DRQ                       : in    std_logic;                           -- WD1773 Data Request.
        DDENn                     : out   std_logic;                           -- WD1773 Double Data Rate Enable.
        SIDE1                     : out   std_logic;                           -- Side 1 of disk select.
        MOTOR                     : out   std_logic;                           -- Motor on signal.
        DRVSAn                    : out   std_logic;                           -- Drive A select.
        DRVSBn                    : out   std_logic;                           -- Drive B select.
        DRVSCn                    : out   std_logic;                           -- Drive C select.
        DRVSDn                    : out   std_logic;                           -- Drive D select.

        -- Clocks.
        CLK_16M                   : in    std_logic;                           -- 16MHz primary oscillator.
        CLK_FDC                   : out   std_logic;                           -- 8MHz clock to drive WD1773.
        CLK_BUS0                  : in    std_logic                            -- Host clock.
    );
END entity;

architecture rtl of sfd700 is

begin

    cpldl128Toplevel : entity work.cpld128
    port map
    (    
        -- Z80 Address Bus
        Z80_ADDR                  => Z80_ADDR,                                 -- Host Address Bus.

        -- Z80 Data Bus
        Z80_DATA                  => Z80_DATA,                                 -- Host Data Bus.
        
        -- Z80 Control signals.
        Z80_M1n                   => Z80_M1n,                                  -- Host M1n input.
        Z80_RDn                   => Z80_RDn,                                  -- Host RDn input.
        Z80_WRn                   => Z80_WRn,                                  -- Host WRn input.
        Z80_IORQn                 => Z80_IORQn,                                -- Host IORQn input.
        Z80_MREQn                 => Z80_MREQn,                                -- Host MREQn input.
        Z80_INT                   => Z80_INT,                                  -- Host INT output, active high.
        Z80_EXWAITn               => Z80_EXWAITn,                              -- Host external Wait output.

        -- Reset.
        Z80_RESETn                => Z80_RESETn,                               -- Host RESET signal.

        -- Inverted Data to FDC and High Address Bits to ROM/RAM.
        ID                        => ID,                                   

        -- ROM/RAM Control Signals.
        ROM_A10                   => ROM_A10,                                  -- Flash ROM A10 line - additional address bit and used for MZ-80A DRQ code selection.
        RAM_A10                   => RAM_A10,                                  -- RAM A10 line - additional address bit.
        ROM_CSn                   => ROM_CSn,                                  -- Chip select for Flash ROM.
        RAM_CSn                   => RAM_CSn,                                  -- Chip select for Flash RAM.
        RSV                       => RSV,                                      -- Reserved.

        -- Interface Configuration.
        MODE                      => MODE,                                     -- Jumper settings to configure interface behaviour.

        -- Floppy Disk Interface.
        FDCn                      => FDCn,                                     -- WD1773 chip select.
        INTRQ                     => INTRQ,                                    -- WD1773 Interrupt.
        DRQ                       => DRQ,                                      -- WD1773 Data Request.
        DDENn                     => DDENn,                                    -- WD1773 Double Data Rate Enable.
        SIDE1                     => SIDE1,                                    -- Side 1 of disk select.
        MOTOR                     => MOTOR,                                    -- Motor on signal.
        DRVSAn                    => DRVSAn,                                   -- Drive A select.
        DRVSBn                    => DRVSBn,                                   -- Drive B select.
        DRVSCn                    => DRVSCn,                                   -- Drive C select.
        DRVSDn                    => DRVSDn,                                   -- Drive D select.

        -- Clocks.
        CLK_16M                   => CLK_16M,                                  -- 16MHz primary oscillator.
        CLK_FDC                   => CLK_FDC,                                  -- 8MHz clock to drive WD1773.
        CLK_BUS0                  => CLK_BUS0                                  -- Host clock.
    );

end architecture;
