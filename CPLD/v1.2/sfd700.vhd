-------------------------------------------------------------------------------------------------------
--
-- Name:            sfd700.vhd
-- Created:         July 2023
-- Author(s):       Philip Smart
-- Description:     SFD700 CPLD configuration file.
--                                                     
--                  This module contains parameters for the CPLD in the SFD700 Floppy Disk Interface
--                  project.
--
-- Credits:         
-- Copyright:       (c) 2018-23 Philip Smart <philip.smart@net2net.org>
--
-- History:         July 2023 - v1.0 - Initial write.

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
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http:--www.gnu.org-licenses->.
---------------------------------------------------------------------------------------------------------
library ieee;
library pkgs;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.sfd700_pkg.all;

entity cpld128 is
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
end entity;

architecture rtl of cpld128 is

    -- CPU Interface internal signals.
    signal Z80_M1ni               :       std_logic;
    signal Z80_RDni               :       std_logic;
    signal Z80_WRni               :       std_logic;
    signal Z80_IORQni             :       std_logic;
    signal Z80_MREQni             :       std_logic;
    signal Z80_INTi               :       std_logic;
    signal Z80_EXWAITni           :       std_logic;

    -- Internal CPU state control.
    signal MEM_ADDR               :       std_logic_vector(15 downto 0) := (others => '0');

    -- Select signals.
    signal MEM_EXXX_SELni         :       std_logic;
    signal MEM_FXXX_SELni         :       std_logic;
    signal FDC_SELni              :       std_logic;
    signal DRIVE_WR_SELni         :       std_logic;
    signal DDEN_WR_SELni          :       std_logic;
    signal SIDE_WR_SELni          :       std_logic;
    signal INTEN_SELni            :       std_logic;
    signal EXXX_RD_SELni          :       std_logic;
    signal EXXX_WR_SELni          :       std_logic;
    signal FXXX_RD_SELni          :       std_logic;
    signal FXXX_WR_SELni          :       std_logic;
    signal RAMEN_RD_SELni         :       std_logic;
    signal RAMEN_WR_SELni         :       std_logic;
    signal MODE_RD_SELni          :       std_logic;
    signal ROMINHSET_WR_SELni     :       std_logic;
    signal ROMINHCLR_WR_SELni     :       std_logic;
    signal ROMDISSET_WR_SELni     :       std_logic;
    signal ROMDISCLR_WR_SELni     :       std_logic;
    signal ROM_SELni              :       std_logic;
    signal RAM_SELni              :       std_logic;

    -- Registers.
    signal REG_DRIVEA             :       std_logic;
    signal REG_DRIVEB             :       std_logic;
    signal REG_DRIVEC             :       std_logic;
    signal REG_DRIVED             :       std_logic;
    signal REG_MOTOR              :       std_logic;
    signal REG_SIDE               :       std_logic;
    signal REG_DDEN               :       std_logic;
    signal REG_INT                :       std_logic;
    signal REG_EXXX_PAGE          :       std_logic_vector(6 downto 0);
    signal REG_FXXX_PAGE          :       std_logic_vector(6 downto 0);
    signal REG_ROMDIS             :       std_logic;
    signal REG_ROMINH             :       std_logic;
    signal REG_RAMEN              :       std_logic;

    -- Selected mode of the interface, ie. which machine it will be plugged into.
    signal IFMODE                 :       integer range 0 to 7 := 0;

    -- Clocks.
    signal CLK_8Mi                :       std_logic := '0';

    -- Functions.
    function to_std_logic(L: boolean) return std_logic is
    begin
        if L then
            return('1');
        else
            return('0');
        end if;
    end function to_std_logic;
begin

    -- Create FDC Clock based on primary clock.
    FDCCLK: process( CLK_16M )
    begin
        if(rising_edge(CLK_16M)) then
            CLK_8Mi              <= not CLK_8Mi;
        end if;
    end process;

    -- Process to register configuration mode on reset.
    SETMODE: process( Z80_RESETn, MODE )
    begin
        if(Z80_RESETn = '0') then
            -- Configuration jumpers specify the machine the SFD700 card will be used with.
            IFMODE               <= to_integer(unsigned(MODE));
        end if;
    end process;

    -- Set Floppy Disk Side.
    -- A write to 0xDD bit D0 = low sets Floppy Disk side 1, high sets side 0.
    SETSIDE: process( Z80_RESETn, CLK_16M, SIDE_WR_SELni )
        variable SIDE_SEL_LASTni : std_logic;
    begin
        if(Z80_RESETn = '0') then
            REG_SIDE             <= '0';
            SIDE_SEL_LASTni      := '0';

        elsif(rising_edge(CLK_16M)) then
            if(SIDE_WR_SELni = '0' and SIDE_SEL_LASTni = '1') then
                REG_SIDE         <= not Z80_DATA(0);
            end if;
            SIDE_SEL_LASTni      := SIDE_WR_SELni;
        end if;
    end process;

    -- Set Double Data Rate Enable.
    -- A write to 0xDE bit D0 = low enables double data rate, high enables single data rate.
    SETDDEN: process( Z80_RESETn, CLK_16M, DDEN_WR_SELni )
        variable DDEN_SEL_LASTni : std_logic;
    begin
        if(Z80_RESETn = '0') then
            REG_DDEN             <= '1';
            DDEN_SEL_LASTni      := '0';

        elsif(rising_edge(CLK_16M)) then
            if(DDEN_WR_SELni = '0' and DDEN_SEL_LASTni = '1') then
                REG_DDEN         <= not Z80_DATA(0);
            end if;
            DDEN_SEL_LASTni      := DDEN_WR_SELni;
        end if;
    end process;

    -- Set Drive Number and Motor
    -- A write to 0xDC, bits D2:0 sets the active drive. Bit 2 high enables the active drive, low disables all drives.
    -- Bit D7 enables the motor.
    SETDRIVE: process( Z80_RESETn, CLK_16M, DRIVE_WR_SELni )
        variable DRIVE_SEL_LASTni: std_logic;
    begin
        if(Z80_RESETn = '0') then
            REG_DRIVEA           <= '0';
            REG_DRIVEB           <= '0';
            REG_DRIVEC           <= '0';
            REG_DRIVED           <= '0';
            REG_MOTOR            <= '0';
            DRIVE_SEL_LASTni     := '0';

        elsif(rising_edge(CLK_16M)) then
            if(DRIVE_WR_SELni = '0' and DRIVE_SEL_LASTni = '1') then
                REG_DRIVEA       <= '0';
                REG_DRIVEB       <= '0';
                REG_DRIVEC       <= '0';
                REG_DRIVED       <= '0';
                REG_MOTOR        <= Z80_DATA(7);
                case(to_integer(unsigned(Z80_DATA(2 downto 0)))) is
                    when 0 =>

                    when 4 =>
                        REG_DRIVEA <= '1';
                    when 5 =>
                        REG_DRIVEB <= '1';
                    when 6 =>
                        REG_DRIVEC <= '1';
                    when 7 =>
                        REG_DRIVED <= '1';

                    when others =>
                end case;
            end if;
            DRIVE_SEL_LASTni       := DRIVE_WR_SELni;
        end if;
    end process;

    -- Set Interrupt Enable
    -- A write to 0xDF enables WD1773 interrupts, a read from 0xDF disables WD1773 interrupts.
    SETINT: process( Z80_RESETn, CLK_16M, INTEN_SELni )
        variable INTEN_SEL_LASTni: std_logic;
    begin
        if(Z80_RESETn = '0') then
            REG_INT              <= '0';
            INTEN_SEL_LASTni     := '0';

        elsif(rising_edge(CLK_16M)) then
            if(INTEN_SELni = '0' and INTEN_SEL_LASTni = '1') then
                REG_INT          <= Z80_RDn;
            end if;
            INTEN_SEL_LASTni     := INTEN_SELni;
        end if;
    end process;

    -- Set FlashROM/RAM EXXX (E300:EFFF) page address. Each bank is 4K but due to the memory mapped I/O, only
    -- E300:EFFF is useable in RFS.
    -- A write t0 0x60 copies D6:0 into the EXXX page address register which selects a required 4K page in region E300:EFFF
    SETEXXXPAGE: process( Z80_RESETn, CLK_16M, IFMODE, EXXX_WR_SELni )
        variable EXXX_SEL_LASTni : std_logic;
    begin
        if(Z80_RESETn = '0') then
            -- Customised UROM containing RFS start bank.
            REG_EXXX_PAGE        <= "0000010";
            EXXX_SEL_LASTni      := '0';
            
        elsif(rising_edge(CLK_16M)) then
            if(EXXX_WR_SELni = '0' and EXXX_SEL_LASTni = '1') then
                REG_EXXX_PAGE    <= Z80_DATA(6 downto 0);
            end if;
            EXXX_SEL_LASTni      := EXXX_WR_SELni;
        end if;
    end process;

    -- Set FlashROM/RAM FXXX (F000:FFFF) page address.
    -- A write to 0x61 copies D6:0 into the FXXX page address register which selects a 4K page
    -- window of ROM/RAM accessible in the FXXX window.
    SETFXXXPAGE: process( Z80_RESETn, CLK_16M, IFMODE, FXXX_WR_SELni )
        variable FXXX_SEL_LASTni : std_logic;
    begin
        if(Z80_RESETn = '0') then
            -- Initial page is set to 0, which is the MZ-80A AFI ROM. The original ROM is 2K so potential to add additional code in the upper block.
            REG_FXXX_PAGE        <= (others => '0');

            -- MZ-700, starting at the second 4k page, set banking registers to 4K block which stores the MZ-700 AFI ROM.
            if(IFMODE = MODE_MZ700) then
                REG_FXXX_PAGE(1 downto 0) <= "01";
            end if;

        elsif(rising_edge(CLK_16M)) then

            -- Set 4k F000:FFFF page address.
            if(FXXX_WR_SELni = '0' and FXXX_SEL_LASTni = '1') then
                REG_FXXX_PAGE    <= Z80_DATA(6 downto 0);
            end if;

            -- Edge detection.
            FXXX_SEL_LASTni      := FXXX_WR_SELni;
        end if;
    end process;

    -- Enable FlashROM or RAM.
    -- A write to 0x62 with D0 = low enables FlashROM, D0 = high enables RAM.
    SETRAMEN: process( Z80_RESETn, CLK_16M, RAMEN_WR_SELni )
        variable RAMEN_SEL_LASTni: std_logic;
    begin
        if(Z80_RESETn = '0') then
            REG_RAMEN            <= '0';

        elsif(rising_edge(CLK_16M)) then
            if(RAMEN_WR_SELni = '0' and RAMEN_SEL_LASTni = '1') then
                REG_RAMEN        <= Z80_DATA(0);
            end if;
            RAMEN_SEL_LASTni     := RAMEN_WR_SELni;
        end if;
    end process;

    -- MZ-700/MZ-1500 paged memory logic. Detect the memory paging I/O operations and enable/disable access to the onboard FlashROM/RAM.
    --
    -- MZ-700 Memory Management Ports                                  
    --            |0000:0FFF|1000:CFFF|D000:FFFF                      
    --            ------------------------------                      
    -- OUT 0xE0 = |DRAM     |         |                               
    -- OUT 0xE1 = |         |         |DRAM                           
    -- OUT 0xE2 = |MONITOR  |         |                               
    -- OUT 0xE3 = |         |         |Memory Mapped I/O              
    -- OUT 0xE4 = |MONITOR  |DRAM     |Memory Mapped I/O             
    -- OUT 0xE5 = |         |         |Inhibit                        
    -- OUT 0xE6 = |         |         |<return>                       
    --
    -- A write to 0xE1 enables RAM in the region 0xD000:FFFF so the onboard FlashROM/RAM should be disabled. A write to 0xE3/0xE4 re-enables
    -- FlashROM/RAM. A write to 0xE5 inhibits all access to region 0xD000:FFFF so the onboard FlashROM/RAM is disabled, write to 0xE6 re-enables it.
    SETHIMEM: process( Z80_RESETn, CLK_16M, ROMINHSET_WR_SELni, ROMINHCLR_WR_SELni, ROMDISSET_WR_SELni, ROMDISCLR_WR_SELni )
        variable ROMINHSET_LAST  : std_logic;
        variable ROMINHCLR_LAST  : std_logic;
        variable ROMDISSET_LAST  : std_logic;
        variable ROMDISCLR_LAST  : std_logic;
    begin
        if(Z80_RESETn = '0') then
            REG_ROMINH           <= '0';
            REG_ROMDIS           <= '0';
            ROMINHSET_LAST       := '0';
            ROMINHCLR_LAST       := '0';
            ROMDISSET_LAST       := '0';
            ROMDISCLR_LAST       := '0';

        elsif(rising_edge(CLK_16M)) then
            if(ROMINHSET_WR_SELni = '0' and ROMINHSET_LAST = '1') then
                REG_ROMINH       <= '1';
            end if;
            if(ROMINHCLR_WR_SELni = '0' and ROMINHCLR_LAST = '1') then
                REG_ROMINH       <= '0';
            end if;
            if(ROMDISSET_WR_SELni = '0' and ROMDISSET_LAST = '1') then
                REG_ROMDIS       <= '1';
            end if;
            if(ROMDISCLR_WR_SELni = '0' and ROMDISCLR_LAST = '1') then
                REG_ROMDIS       <= '0';
            end if;
            ROMINHSET_LAST       := ROMINHSET_WR_SELni;
            ROMINHCLR_LAST       := ROMINHCLR_WR_SELni;
            ROMDISSET_LAST       := ROMDISSET_WR_SELni;
            ROMDISCLR_LAST       := ROMDISCLR_WR_SELni;
        end if;
    end process;

    -- Memory address select.
    MEM_EXXX_SELni               <= '0'                                    when Z80_MREQn = '0' and unsigned(Z80_ADDR(15 downto 8)) >= X"E3" and unsigned(Z80_ADDR(15 downto 8)) < X"F0"
                                    else '1';
    MEM_FXXX_SELni               <= '0'                                    when Z80_MREQn = '0' and unsigned(Z80_ADDR(15 downto 8)) >= X"F0" and unsigned(Z80_ADDR(15 downto 8)) <= X"FF"
                                    else '1';
    ROM_SELni                    <= '0'                                    when (IFMODE = MODE_MZ700  or IFMODE = MODE_MZ1500) and REG_ROMINH = '0' and REG_ROMDIS = '0' and REG_RAMEN = '0' and (MEM_EXXX_SELni = '0' or MEM_FXXX_SELni = '0')
                                    else
                                    '0'                                    when (IFMODE = MODE_MZ1200 or IFMODE = MODE_MZ80A)                                            and REG_RAMEN = '0' and (MEM_EXXX_SELni = '0' or MEM_FXXX_SELni = '0')
                                    else '1';
    RAM_SELni                    <= '0'                                    when (IFMODE = MODE_MZ700  or IFMODE = MODE_MZ1500) and REG_ROMINH = '0' and REG_ROMDIS = '0' and REG_RAMEN = '1' and (MEM_EXXX_SELni = '0' or MEM_FXXX_SELni = '0')
                                    else
                                    '0'                                    when (IFMODE = MODE_MZ1200 or IFMODE = MODE_MZ80A)                                            and REG_RAMEN = '1' and (MEM_EXXX_SELni = '0' or MEM_FXXX_SELni = '0')
                                    else '1';

    -- I/O Port select.
    FDC_SELni                    <= '0'                                    when Z80_IORQn = '0' and (Z80_WRn = '0' or Z80_RDn = '0') and unsigned(Z80_ADDR(7 downto 0)) >= X"D8" and unsigned(Z80_ADDR(7 downto 0)) < X"DC"
                                    else '1';
    DRIVE_WR_SELni               <= '0'                                    when Z80_IORQn = '0' and Z80_WRn = '0'                    and unsigned(Z80_ADDR(7 downto 0)) = X"DC"
                                    else '1';
    DDEN_WR_SELni                <= '0'                                    when Z80_IORQn = '0' and Z80_WRn = '0'                    and unsigned(Z80_ADDR(7 downto 0)) = X"DE"
                                    else '1';
    SIDE_WR_SELni                <= '0'                                    when Z80_IORQn = '0' and Z80_WRn = '0'                    and unsigned(Z80_ADDR(7 downto 0)) = X"DD"
                                    else '1';
    INTEN_SELni                  <= '0'                                    when Z80_IORQn = '0' and (Z80_WRn = '0' or Z80_RDn = '0') and unsigned(Z80_ADDR(7 downto 0)) = X"DF"
                                    else '1';
    EXXX_RD_SELni                <= '0'                                    when Z80_IORQn = '0' and Z80_RDn = '0'                    and unsigned(Z80_ADDR(7 downto 0)) = X"60"
                                    else '1';
    EXXX_WR_SELni                <= '0'                                    when Z80_IORQn = '0' and Z80_WRn = '0'                    and unsigned(Z80_ADDR(7 downto 0)) = X"60"
                                    else '1';
    FXXX_RD_SELni                <= '0'                                    when Z80_IORQn = '0' and Z80_RDn = '0'                    and unsigned(Z80_ADDR(7 downto 0)) = X"61"
                                    else '1';
    FXXX_WR_SELni                <= '0'                                    when Z80_IORQn = '0' and Z80_WRn = '0'                    and unsigned(Z80_ADDR(7 downto 0)) = X"61"
                                    else '1';
    RAMEN_RD_SELni               <= '0'                                    when Z80_IORQn = '0' and Z80_RDn = '0'                    and unsigned(Z80_ADDR(7 downto 0)) = X"62"
                                    else '1';
    RAMEN_WR_SELni               <= '0'                                    when Z80_IORQn = '0' and Z80_WRn = '0'                    and unsigned(Z80_ADDR(7 downto 0)) = X"62"
                                    else '1';
    MODE_RD_SELni                <= '0'                                    when Z80_IORQn = '0' and Z80_RDn = '0'                    and unsigned(Z80_ADDR(7 downto 0)) = X"63"
                                    else '1';
    ROMINHSET_WR_SELni           <= '0'                                    when Z80_IORQn = '0' and Z80_WRn = '0'                    and unsigned(Z80_ADDR(7 downto 0)) = X"E5"
                                    else '1';
    ROMINHCLR_WR_SELni           <= '0'                                    when Z80_IORQn = '0' and Z80_WRn = '0'                    and unsigned(Z80_ADDR(7 downto 0)) = X"E6"
                                    else '1';
    ROMDISSET_WR_SELni           <= '0'                                    when Z80_IORQn = '0' and Z80_WRn = '0'                    and unsigned(Z80_ADDR(7 downto 0)) = X"E1"
                                    else '1';
    ROMDISCLR_WR_SELni           <= '0'                                    when Z80_IORQn = '0' and Z80_WRn = '0'                    and (unsigned(Z80_ADDR(7 downto 0)) = X"E3" or unsigned(Z80_ADDR(7 downto 0)) = X"E4")
                                    else '1';

    -- WD1773 master clock.
    CLK_FDC                      <= CLK_8Mi;

    -- Data bus control.
    Z80_DATA                     <= not ID                                 when FDC_SELni = '0'     and Z80_WRn = '1'          -- WD1773
                                    else
                                    '0' & REG_EXXX_PAGE                    when EXXX_RD_SELni = '0'                            -- EXXX Register contents.
                                    else
                                    '0' & REG_FXXX_PAGE                    when FXXX_RD_SELni = '0'                            -- FXXX Register contents.
                                    else
                                    "0000000" & REG_RAMEN                  when RAMEN_RD_SELni = '0'                           -- ROM/RAM Enable register contents.
                                    else
                                    "00000" & MODE                         when MODE_RD_SELni = '0'                            -- Configured mode.
                                    else
                                    (others => 'Z');
    -- ID is the inverted data bus, the WD1773 uses inverted data. ID doubles up as the FlashROM/RAM upper address bits when not being used for the WD1773.
    ID                           <= not Z80_DATA                           when Z80_WRn = '0' and FDC_SELni = '0'
                                    else
                                    REG_EXXX_PAGE & Z80_ADDR(11)           when MEM_EXXX_SELni = '0'
                                    else
                                    REG_FXXX_PAGE & Z80_ADDR(11)           when MEM_FXXX_SELni = '0'
                                    else
                                    (others => 'Z');

    -- Host interrupts and wait processing.
    Z80_INT                      <= INTRQ                                  when REG_INT = '1'
                                    else '0';
    Z80_EXWAITni                 <= '1';
    Z80_EXWAITn                  <= Z80_EXWAITni;

    -- FlashROM/RAM Address A10 - this is used on the MZ-80A/MZ-1200 as a means of speeding up data retrieval from the WD1773 where DRQ is used as the address bit and dupliate ROM code appears in each 1K segment except the upper bytes, 0x3FE.
    ROM_A10                      <= '1'                                    when (IFMODE = MODE_MZ1200 or IFMODE = MODE_MZ80A) and DRQ = '1'
                                    else Z80_ADDR(10);
    RAM_A10                      <= Z80_ADDR(10);

    -- FlashROM/RAM Chip Select.
    ROM_CSn                      <= ROM_SELni;
    RAM_CSn                      <= RAM_SELni;

    -- Floppy Disk Interface Signals.
    FDCn                         <= FDC_SELni;
    DRVSAn                       <= not REG_DRIVEA;
    DRVSBn                       <= not REG_DRIVEB;
    DRVSCn                       <= not REG_DRIVEC;
    DRVSDn                       <= not REG_DRIVED;
    MOTOR                        <= REG_MOTOR;
    SIDE1                        <= not REG_SIDE;
    DDENn                        <= not REG_DDEN;

    -- Reserved pins.
    RSV                          <= '0';

end architecture;
