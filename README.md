# SFD-700

Repository updated 08/11/2023

v1.0 - Functions in most machines, albeit, for an MZ-700 it requires MZ-700 memory mapping logic if used outside of an MZ-1U06 expansion box. Recommend only to view, not to build.

v1.1 - Functions but restrictions imposed with the GAL registers (ie. one clock all register) it couldnt satisfy my latest requirements, ie. MZ-700 memory mapping logic and Flash ROM paging. - Recommend only to view, not to build.

v1.2 - Hardware functions well on all machines tested (MZ-80A, MZ-700, MZ-1500, MZ-2000) and updates made to the Rom Filing System which basically works but has a few bugs I need to work out (fully functions as an FDC just the ROM based component of RFS has a bug and also I want to add FDC commands to the RFS Monitor). Also started updating CP/M and Basic (SA-5510, NASCOM Basic etc).

Documentation needs to be updated as it is out of date on my website, wip!

A Floppy Disk Interface card for the Sharp MZ series of machines (MZ-80B/MZ-80A/MZ-700/MZ-800/MZ-1500/MZ-2000/MZ-2200).

This project is based on an iconic floppy disk interface card from the 1980's by the Aachen based company, Kersten & Partner GmbH. The company produced two cards,
the SFD-700 for the Sharp MZ-700 and the SFD-800 for the Sharp MZ-800. 

Owning an original SFD-800, I reproduced the SFD-800 from the original schematic and the design can be seen here: https://eaw.app/sfd800/. This card has been well
tested and as the SFD-800 was quite a flexible design, it also worked in the MZ-80B/MZ-800/MZ-1500/MZ-2000/MZ-2200 computers. Unfortunately it didnt cater for the Sharp MZ-700 or indeed the Sharp MZ-80A.

To address the requirement of a floppy interface for the Sharp MZ-700 and MZ-80A, I considered reproducing the SFD-700 exactly but analysis showed it wouldnt work in an MZ-80A which uses a hardware trick to
address the CPU speed shortcomings. I thus decided, based on the SFD-800 schematics, to create a version 2 of the SFD-700 design which would work in all the Sharp MZ series computers.

Please see my website (in due course), https://eaw.app for more documentation and any recent updates.

If you want to build a v1.2 card, I have 6 boards spare I can ship, just pay me for the postage.
