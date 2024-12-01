function hog_features = custom_hog(img)
    % for a 32x32 binary image
    % for a fixed grid size of 4x4 (8x8 pixel each)
    % for 9 histogram bin (0-180 divided into 20 deg each bin)

    num_bins = 9;
    bin_edges = [0 20 40 60 80 100 120 140 160 180];
    
    index = 1;
    hog_features = zeros(1,144);
    for i = 1:4
        for j = 1:4
            % Extract the current cell (8x8 region)
            rowStart = (i-1)*8 + 1;
            rowEnd = i*8;
            colStart = (j-1)*8 + 1;
            colEnd = j*8;
            cellImg = img(rowStart:rowEnd, colStart:colEnd);
            [cellMag, cellOri] = Grad_func(cellImg);

            CellHist = zeros(num_bins);
            for bin = 1:num_bins
                binMask = (cellOri >= bin_edges(bin) & cellOri < bin_edges(bin+1));
                cellHist(bin) = sum(cellMag(binMask), 'all');
            end
            
            hog_features(index:index+num_bins-1) = cellHist;
            index = index + num_bins;
        end
    end   
        
end


