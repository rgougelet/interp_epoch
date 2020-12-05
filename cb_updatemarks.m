EEG.etc.wininterp = sortrows(TMPREJ,1);
EEG.etc.wininterp = unique(EEG.etc.wininterp, 'rows');
wn = EEG.etc.wininterp;
% making an easier variable to work with
ch = [];
for i = 1:size(wn,1)
	chi = find(wn(i,6:end));
	if isempty(chi); chi = 0; end
	ch(i,:) = chi;
end
wnt = [wn(:,1:2)/EEG.pnts, wn(:,5), ch];
EEG.etc.wn = wnt;
% [EEG.reject.rejmanual, EEG.reject.rejmanualE] = ...
% 	eegplot2trial(EEG.etc.wininterp, ...
% 	EEG.pnts+1, EEG.trials, [1 1 .783], []);
rejm = false(1,EEG.trials);
list_of_trials_marked = round(EEG.etc.wininterp(:,1)/EEG.pnts)+1;
whole_trials = all(EEG.etc.wininterp(:,3:5)==[1 1 .783],2);
rejm(unique(list_of_trials_marked(whole_trials)))= true;
EEG.reject.rejmanual = rejm;

% EEG.etc.wininterp([false; ~diff(list_of_trials_marked(whole_trials))],:) = [];

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




% [EEG.etc.wininterp(:,1)/700, ...
% EEG.etc.wininterp(:,2)-EEG.etc.wininterp(:,1),...
%  EEG.etc.wininterp(:,3:5)]

% [EEG.etc.wininterp(1:10,1)/700, ...
% EEG.etc.wininterp(1:10,2)-EEG.etc.wininterp(1:10,1),...
%  EEG.etc.wininterp(1:10,3:5)]

% EEG.etc.wininterp(:,1:5)

% [EEG.etc.wininterp(:,1), EEG.etc.wininterp(:,2), EEG.etc.wininterp(:,3:5)]
% EEG.reject.rejmanual
% 
% TMPREJ(:,1:2)/700
% 
% TMPREJ(:,1:2)/701