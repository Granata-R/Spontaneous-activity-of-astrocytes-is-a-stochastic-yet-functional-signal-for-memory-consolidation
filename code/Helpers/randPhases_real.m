function out = randPhases_real(x,dim)
% out = RANDPHASES_REAL(x,dim)
% the idea is: compute the fft of the real input that is composed by complex
% values like A*e^(i*W) where A is the amplitude and W is the phase. The
% output will be a real sequence with the same power as the input (same A
% values of the fourier transform) but random phases (W values of the fourier
% transform). 

% x is the input matrix with 2 or 3 dimensions. for the moment x must be 2D or 3D
% dim is the dimension along with you want to compute the fft and randomize
% the phases.

    arguments
        x {mustBeNumeric}
        dim = 1 % this means that dim is an optional input argument. If the user does not
        % choose dim, then dim is automatically set to 1 (as in most of the matlab functions like
        % mean, median, max and so on).
    end
    
    % permute x so that dim is the 1st dimension
    s = size(x); % vector containing the lenght of every dimension of x
    d = 1:numel(s); % vector containng integers from 1 to the number of dimensions of x (in this case 2 or 3)
    d(d==dim) = []; % remove from d the element corresponding to the dim choosen by the user
    x = permute(x,[dim,d]); % Permute x to make dim the 1st dimension.
    
    % fourier transform on the 1st dimension.
    F = fft(x,[],1);
    
    % check input length
    l = size(x,1);
    % check if the number of timepoints is odd or even.
    isodd = rem(l,2);
    % save the number of half the elements of l (you'll se later why)
    halfL = floor(l/2);
    
    % the fft output for a real time series of length L (a vector of doubles)
    % is a vector of complex doubles of lenght L, organized like this: the
    % first element is the fourer transform relative to the frequency = 0Hz.
    % The following elements correspond to the real frequencies, with increments of
    % 1/T, where T is the time duration of the input time series. This
    % proceeds until the nyquist frequency. If L is even, the (halfL+1)-th
    % element is the nyquist freqency, otherwise the nyquist frequency is
    % not represented in the fft output. The following elements represent
    % the negative frequencies (reversed).
    % Now, for a real signal the fourier transform elements corresponding
    % to the negative frequencies are the complex conjugate of those of the
    % positive frequencies. Since freq=0Hz (and possibly freq=0Hz) are
    % common between positive and negative fequencies, their phase can only
    % be zero.
    
    % consider the real elements (but zero). If l is even, the (halfL+1)th
    % element is the nyquist freqency, whose phase must remain 0. Otherwise
    % halfL+1 must be included. Stopping at halfL+1 seems to be a cuccing
    % trick.
    realTransf = F(2:halfL+isodd,:);
    randphases = rand(size(realTransf)).*2*pi-pi;
    newReal = abs(realTransf).*exp(1i.*randphases);
    newImg = flipud(conj(newReal));
    
    if isodd
        newTrans = cat(1,F(1,:),newReal,newImg);
    else
        newTrans = cat(1,F(1,:),newReal,F(halfL+1,:),newImg);
    end
    
    out = ifft(newTrans);
    d = 1:numel(s);
    d([1 dim]) = d([dim 1]);
    out = permute(out,d);
    assert(isequal(s,size(out)),'Uncorrect permutation')
end  
