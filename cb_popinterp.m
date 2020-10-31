EEG.etc.wininterp = TMPREJ;
[EEG.reject.rejmanual, EEG.reject.rejmanualE] = eegplot2trial(EEG.etc.wininterp, EEG.pnts, EEG.trials, [1           1       0.783], []);
clear nEEG;
disp('Channels successfully marked for single-trial interpolation.');
disp('Be sure to actually perform the interpolation using the Interpolate plugin menu option.');


% if ~isempty(TMPREJ),  icaprefix = '';
% 	[tmprej tmprejE] = eegplot2trial(TMPREJ,701, EEG.trials, [1           1       0.783], []);
% 	if ~isempty(tmprejE),     tmprejE2 = zeros(63, length(tmprej));
% 		tmprejE2([1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63],:) = tmprejE;
% 	else,
% 		tmprejE2 = [];
% 	end;
% 	EEG.reject.rejmanual = tmprej;
% 	EEG.reject.rejmanualE = tmprejE2;
% 	tmpstr = [ 'EEG.reject.' icaprefix 'rejmanual' ];
% 	if ~isempty(tmprej)
% 		eval([ 'if ~isempty(' tmpstr '),' tmpstr '=' tmpstr '| tmprej; else, ' tmpstr '=tmprej; end;' ]);
% 	end;
% 	if ~isempty(tmprejE2)
% 		eval([ 'if ~isempty(' tmpstr 'E),' tmpstr 'E=' tmpstr 'E| tmprejE2; else, ' tmpstr 'E=tmprejE2; end;' ]);
% 	end;
% 	warndlg2(strvcat('Epochs (=trials) marked for rejection have been noted.','To actually reject these epochs, use the same menu item to','inspect/reject data and select "Reject marked trials" checkbox'), 'Warning');
% 	[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
% 	eeglab('redraw');
% end;
% clear indextmp colortmp icaprefix tmpcom tmprej tmprejE tmprejE2 TMPREJ;'

