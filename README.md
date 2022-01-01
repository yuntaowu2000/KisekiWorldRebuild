# Kiseki World Rebuild
## Intro
This project reconnects cities in kiseki series with their surrounding highways and paths using Unity.

## Finished cities and paths:  
- Liberl(SC): 
  - Rolent: City of Rolent, mayor house, Elize highway (Bright house, Gurune gate), Milch main road, 
  - Bose: City of Bose, East Bose Highway (Eisen Road + Haken Gate), Krone Trail (Krone Pass), Ravennue, New Ansel Path (Valleria Lake), West Bose Highway
  - Ruan: City of Ruan, Manoria Village, Gull seaside way (Mercia Orphanage), Jenis Royal Academy, Aurian Cause Way (AirLetten)
  - Zeiss: City of Zeiss, Tratt Plains Road(Elmo Village + Wolf Fort), Ritter Roadway (Sanktheim Gate)
  - Grancel: City of Grancel, Grancel Castle, Royal Avenue
- Crossbell(Zero/Ao):
  - All regions
- Crossbell(Sen/Hajimari):
  - City
  - East Highway + Armolica + Ancient battlefield
  - West 1 + Nox + Police Academy
  - Mainz + Rosenberg
  - Ursula + Hospital + Elm
  - **Note:** Michellam and Stargazer are not included
  - **Note2:** model files are not included in GitHub repo due to size limits. Those models can be downloaded [here](https://mega.nz/file/LxsCzZjQ#A1-umIKjQz6m_MEdh9hwMd_xlDLnPbmiIBjVGfgtKFg). Download and extract the `CityNew` folder into `Assets/models/Crossbell` and then start Unity.
- Erebonia (Sen 1/2):
  - Sutherland:
    - Hamel (Sen 3)
  - Kreuzen:
    - Bareahard + North Kreuzen Highway + South Kreuzen Highway + Aurochs Canyon Path + Aurochs Fort
    - Legram + Lohengrin Castle + Ebel Highway
    - Celdic + West Celdic Highway + East Celdic Highway + Twin Dragons Bridge
    - Garrelia Fortress (undestroyed) + Garrelia Path
  - Nortia:
    - Ymir + Ymir Valley
    - Roer + Sachsen mountain path (Sachsen iron mine) + Spina Byroad + Nortia Highway(Schwarz Drache Barrier)
  - Nord: (Not working)
    - Nord South, Nord Village, Nord North, Nord village (not able to connect well)
  - Capital:
    - Trista town + Thors Academy
    - Heimdallr: central station + Vainqueur Street + Dreichels Plaza (Varflame Plaza), other regions do not fit due to sizes
  - **Note:** Due to file sizes and processing time, other models from sen 3, 4 (West Erebonia) will not be included. Regional models can be viewed on [trails-Cafe](https://trails-game.com/regions/).

## Runtime/Build Requirements
- Unity version 2020.1.15f1, should be compatible with newer version of Unity
- [Unity new input system](https://docs.unity3d.com/Packages/com.unity.inputsystem@1.0/manual/QuickStartGuide.html)
- New Crossbell models can be downloaded [here](https://mega.nz/file/LxsCzZjQ#A1-umIKjQz6m_MEdh9hwMd_xlDLnPbmiIBjVGfgtKFg). Download and extract the `CityNew` folder into `Assets/models/Crossbell` and then start/restart Unity and import all models.
  - If you want to build up the models in blender, you will need the json files and the blender python script included in the archive. Check this [repo](https://github.com/yuntaowu2000/trails-games-tools) for details.
- **Note:** Most regions require a reconfiguration of player object due to the integration of [new Unity input system and controller](https://assetstore.unity.com/packages/essentials/starter-assets-third-person-character-controller-196526). However, if the base scene is New Crossbell and you add teleportation to other scenes, reconfiguration is not required.  

## Credits

All models extracted from [kiseki games](https://falcom.co.jp/kiseki/) using code from [uyjulian](https://gist.github.com/uyjulian/6c590476819bf3bfde6fc78aa3765698). My version of code is [here](https://github.com/yuntaowu2000/trails-games-tools/tree/main/models).  

## Warning
Copyrights of models and musics belong to [Nihon Falcom Corporation](https://falcom.co.jp/). This work is associated with https://trails-game.com/. Commercial use is prohibited.
