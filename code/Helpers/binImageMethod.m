function [binnedImage] = binImageMethod(inputI, bin, method)
%binImage
% September, 9, 2017 GMR
% This function takes the input image and bins it of the specified square
% amount
% Width ad Height of the input image must be integer multiple of the bin
% factor. If this is not true, the image is cropped to the closest
% acceptable couple of values.
% December, 19, 2020 RG
% 
%
%
% Added some additional methods to the binning computation. Default method will be the sum() one, which in relative terms is
% the same thing as using mean() function, and this is why I didn't put any "Average" option. 
% Other methods might be picked by the user via the app.binMethodDD.Value of the dropdown menu placed in the 'Maps' tab, here indicated as "method".
[w h] = size(inputI);
total = w*h;

% check size against bin coefficent.
wb = w/bin;
hb = h/bin;

%tmp = reshape(inputI,bin,hb,wb*bin) %?

	if method == "Sum"

		temp1 = sum(reshape(inputI,bin,[]),1 );
		temp2 = reshape(temp1,wb,[]).';             %Note transpose

		temp3 = sum(reshape(temp2,bin,[]),1);
		binnedImage = reshape(temp3,hb,[]).';       %Note transpose

	elseif method == "Max"
		
		% December, 19, 2020 RG
		%
		% This method takes into account only the pixel with the maximum value within the bin area. 
                % As it happens with the original sum() method, this operation is performed on columns first and then on rows.
		% The output seems not to be as trustable as the sum() method, although I wanted
                % to implement the analogous ImageJ function. Maybe it will be useful one day for other purposes.
		% The code is pretty much the same as the one utilized for the sum() method; the only thing that changes is 
		% that the max() function does not require any numerical argument after the matrix: during the calculation of the mean
                % we needed instead something like sum(matrix, 1), in which 1 was the dim argument.
		% S = sum(A,dim) returns the sum along dimension dim. For example, if A is a matrix, 
		% then sum(A,2) is a column vector containing the sum of each row. Earlier we summed columns (dim = 1).
		temp1 = max(reshape(inputI,bin,[]) );
		temp2 = reshape(temp1,wb,[]).';             %Note transpose

		temp3 = max(reshape(temp2,bin,[]) );
		binnedImage = reshape(temp3,hb,[]).';       %Note transpose

	elseif method == "Min"

		% December, 19, 2020 RG
		%
		% This method takes into account only the pixel with the maximum value within the bin area. 
                % As it happens with the original sum() method, this operation is performed on columns first and then on rows.
		% The output seems not to be as trustable as the sum() method, although I wanted
                % to implement the analogous ImageJ function. Maybe it will be useful one day for other purposes.
		% The code is pretty much the same as the one utilized for the sum() method; the only thing that changes is 
		% that the max() function does not require any numerical argument after the matrix: during the calculation of the mean
                % we needed instead something like sum(matrix, 1), in which 1 was the dim argument.
		% S = sum(A,dim) returns the sum along dimension dim. For example, if A is a matrix, 
		%then sum(A,2) is a column vector containing the sum of each row. Earlier we summed columns (dim = 1).
		temp1 = min(reshape(inputI,bin,[]) );
		temp2 = reshape(temp1,wb,[]).';             %Note transpose

		temp3 = min(reshape(temp2,bin,[]) );
		binnedImage = reshape(temp3,hb,[]).';       %Note transpose
	
	elseif method == "Median"
		
		% December, 20, 2020 RG
		%
		% Last method is median between the pixels of the bin. In this case I could not use the median() function of MATLAB, because,
		% since we are applying it twice on a 2*n reshape matrix, the function is not able to know which the central values are,
		% and therefore it would compute the mean rather than the median.
		% So, one possible solution is to use a function of matlab, medfilt2(), which computes automatically the median values
		% on a desired bin range. The problem about medfilt2() is that it keeps the size of the original matrix, interpolating central
		% values. The following code (which might be quite slow) has the purpose of removing these interpolated in-between rows and columns,
		% thus resizing the final matrix to the bin factor.
		% Also I decided to keep two separate variables for rows and columns, just in case one needs to process an image which is not a square matrix.

		% First, apply medfilt2(). This function is generally used to mask off noise.
		b= medfilt2(inputI,[bin bin]); 

		% Allocate a new matrix which has the same size of the original. I will fill up it with zeros, and I will
		% insert in it only the median rows and columns, thus not considering the interpolated ones. 
		% The interesting rows and columns are alternated by n number in which n is the bin length. This means that if
		% the binning is 4, then the interesting rows and colums will be 1,5,9,13,17...
		new = zeros(w,h); 

		% In this for I want to make "new" matrix inherit only the interesting rows
		for i = 0:1:(wb-1)

			new((1+i),:) = b((1+i*bin),:); %interesting rows

		end

		% Then, I have to reapply a similar loop, but this time to keep the intereseting columns. I decided to use a second matrix "new2"
		new2 = zeros(w,h); %preallocate.
		
		for i = 0:1:(hb-1)

			new2(:,(1+i)) = new(:,(1+i*bin)); %interesting columns

		end


		% At this point, I obtained by binned image, in which every point is the median of the bin*bin neighborhood of the original
		% picture. Still, this binned picture is inserted in the original , larger zeros matrix, occupying its top-left
		% corner. What I want to do now is to remove all the bottom rows and right columns, which are all filled with zeros. 
		% Thus I am obtaining one final binned picture which is also resized.

		newF = new2((1:wb),:); %I eliminate all the rows filled with 0, placed after wb
		binnedImage = newF(:,(1:hb)); %I eliminate all the columns filled with 0, placed after wb



end
