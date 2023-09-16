# DEM (GeoTiff) Terrain Tiles to Unity terrain byte 

This tool efficiently transforms multiple DEM-GeoTiff files into World Mercator projection main data represented in bytes. Additionally, it generates a coordinate TXT file, which proves instrumental in the organized management of individual tiles according to their source files. Specifically designed for use in Unity 3D, this tool serves as runtime terrain data, allowing for the dynamic loading of locations based on the final results.

# How to use:

Name your .tif files with a "t_" prefix, including row and column numbers, such as "t_1_1.tif." Organize them within your main tile folder as outlined below:

```matlab
folderName = "your-folder";

```

Each row is represented as a folder bearing the "R" prefix. Within each row folder, you'll find files distinguished by the "D" and "M" prefixes. The "D" files contain the primary terrain height data, while the "M" files contain detailed metadata for each dataset.

**All Meta details are stored in Json structure.**
