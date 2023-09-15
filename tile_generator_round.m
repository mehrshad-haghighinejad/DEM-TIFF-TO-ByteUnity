clc;
clear;
close all;

folderName = "your-folder";
converetedFolderName = folderName + "your-final-folder";
mkdir( converetedFolderName);
directoryListFile = fopen(converetedFolderName + '/directories.txt', 'wt' );


files = dir(folderName+'/*.tif');


for file = files'

    name =  erase(file.name,".tif");
    name = erase(name,"t_");
     
    Meta = georasterinfo(folderName +"/" + file.name);
    [Data,Detail] = readgeoraster(folderName +"/" + file.name);
    Data = double(Data);

    % width & height 
    RealWidth = Detail.RasterExtentInWorldX + Detail.SampleSpacingInWorldX;
    RealHeight = Detail.RasterExtentInWorldY + Detail.SampleSpacingInWorldY;

    % longitude
    x1 = double(Detail.XWorldLimits(1));
    x2 = double(Detail.XWorldLimits(1) + RealWidth);

    % latitude
    y1 = double(Detail.YWorldLimits(1));
    y2 = double(Detail.YWorldLimits(1) + RealHeight);
    
    % min & max elevation
    minElevation = 0;
    maxElevation = 10000;

    RealMinElevation = str2double(Meta.Metadata.TIFFTAG_MINSAMPLEVALUE);
    RealMaxElevation = str2double(Meta.Metadata.TIFFTAG_MAXSAMPLEVALUE);

    FinalImage = [];    

    Subtotal = maxElevation - minElevation;
    for i = 1:size(Data,1)
      for k = 1:size(Data,2)
          FinalImage(i,k) =(Data(i,k) - minElevation)./ Subtotal;
      end
    end
    
    FinalImage = flip(FinalImage);
    
    yString = "R" + string(fix(y1));
    xString = string(fix(x1));
    
    MetaData = struct("tileNumber",name,"columnStart",x1,"rowStart",y1, "columnEnd",x2, "rowEnd",y2, "width",RealWidth, "height",RealHeight, "minElevation",minElevation, "maxElevation",maxElevation, "realMinElevation", RealMinElevation, "realMaxElevation", RealMaxElevation, "rasterSizeWidth",Meta.RasterSize(2),"rasterSizeHeight",Meta.RasterSize(1),"fileColumnStart",fix(x1),"fileColumnEnd",fix(x2),"fileRowStart",fix(y1),"fileRowEnd",fix(y2));
    
    if ~exist(converetedFolderName + "/" + yString, 'dir')
       mkdir( converetedFolderName + "/" + yString); 
       fprintf(directoryListFile,'%s,\n', string(fix(y1)));   
    end

    DataListFile = fopen(converetedFolderName + "/" +yString + '/files.txt' ,"a");
    fprintf(DataListFile,'%s,\n',xString);
     fclose(DataListFile);
     
%   simple format
%   writetable(struct2table(MetaData), converetedFolderName + "/" + yString + "/" +"M"+ xString+ ".txt",'Delimiter',',');

%   json format
    metaFile = fopen(converetedFolderName + "/" + yString + "/" +"M"+ xString+ ".txt",'w');
    fwrite(metaFile, jsonencode(MetaData));
    fclose(metaFile);
   
    f = fopen(converetedFolderName + "/" + yString + "/" + "D" + xString  +".txt",'w');
    fwrite(f, FinalImage,'single');
    fclose(f);
    
%   writematrix(FinalImage, converetedFolderName + "/" + yString + "/" + "D" + xString  +".txt");
   
end

fclose(directoryListFile);
