function [R,G,B] = bilinear_interpolation_demosaic(oldR, oldG, oldB)
    [height, width] = size(oldR);
    R = helper(oldR, true, height, width);
    B = helper(oldB, true, height, width);
    G = helper(oldG, false, height, width);
end

function [matrix] = helper(oldMatrix, RorB, height, width)
    matrix = oldMatrix;
    for row = 2:(height-1)
        for col = 2:(width-1)
            if oldMatrix(row, col) == 0
                if RorB
                    matrix(row, col) = average_for_R_B(row, col, oldMatrix);
                else
                    matrix(row, col) = average_for_G(row, col, oldMatrix);
                end
            end
        end
    end
end

function [average] = average_for_R_B(currentRow, currentCol, matrix)
    total = 0;
    knownCells = [[currentRow-1,currentCol-1];[currentRow-1,currentCol+1];[currentRow+1,currentCol-1];[currentRow+1,currentCol+1]];
    knownCells = transpose(knownCells);
    for cell = knownCells
        total = total + matrix(cell(1),cell(2));
    end
    average = total/4;
end

function [average] = average_for_G(currentRow, currentCol, matrix)
    total = 0;
    knownCells = [[currentRow-1, currentCol];[currentRow, currentCol-1];[currentRow+1,currentCol];[currentRow, currentCol+1]];
    knownCells = transpose(knownCells);
    for cell = knownCells
        total = total + matrix(cell(1),cell(2));
    end
    average = total/4;
end