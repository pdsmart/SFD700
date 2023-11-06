# SFD-700

<b>06/11/2023 - The designs in this repository are v1.0 and not suitable to be built. I have made two iterations since this design, v1.2 being stable just requires additional firmware development. This will be released in due course, please do not invest time with v1.0 other than to study it.<b>

A Floppy Disk Interface card for the Sharp MZ series of machines (MZ-80B/MZ-80A/MZ-700/MZ-800/MZ-1500/MZ-2000/MZ-2200).

This project is based on an iconic floppy disk interface card from the 1980's by the Aachen based company, Kersten & Partner GmbH. The company produced two cards,
the SFD-700 for the Sharp MZ-700 and the SFD-800 for the Sharp MZ-800. 

Owning an original SFD-800, I reproduced the SFD-800 from the original schematic and the design can be seen here: https://eaw.app/sfd800/. This card has been well
tested and as the SFD-800 was quite a flexible design, it also worked in the MZ-80B/MZ-800/MZ-1500/MZ-2000/MZ-2200 computers. Unfortunately it didnt cater for the Sharp MZ-700 or indeed the Sharp MZ-80A.

To address the requirement of a floppy interface for the Sharp MZ-700 and MZ-80A, I considered reproducing the SFD-700 exactly but analysis showed it wouldnt work in an MZ-80A which uses a hardware trick to
address the CPU speed shortcomings. I thus decided, based on the SFD-800 schematics, to create a version 2 of the SFD-700 design which would work in all the Sharp MZ series computers.

Please see my website (in due course), https://eaw.app for more documentation and any recent updates.
