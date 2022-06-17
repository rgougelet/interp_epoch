clear; close all; clc;
script_dir = 'C:\Users\Rob\Documents\MATLAB\ant_av_eeg\'; 
addpath(script_dir); cd(script_dir);
load_params;
%%
data_dir = 'C:\Users\Rob\Documents\MATLAB\ant_av_eeg\data\';
pre_suffix = 'femnrim'; post_suffix = 'femnrimn';
% pre_suffix = 'femnrimn'; post_suffix = 'femnrimnr';
% pre_suffix = 'fem'; post_suffix = 'femn';
% pre_suffix = 'femn'; post_suffix = 'femnr';
pre_dir = [data_dir, pre_suffix, '\'];
post_dir = [data_dir, post_suffix, '\'];

for subj_i = 1:length(subjs_to_include)
  try
	% load dataset
  subj_id = [subjs_to_include{subj_i},'_'];
	pre_setfile = dir([pre_dir, subj_id, pre_suffix, '.set']);
  post_setfile = dir([post_dir, subj_id, post_suffix, '.set']);
	evalc('preEEG = pop_loadset(''filename'', pre_setfile.name, ''filepath'', pre_dir);');
  evalc('postEEG = pop_loadset(''filename'', post_setfile.name, ''filepath'', post_dir);');
  disp(['Subj ',num2str(subj_i),' ',num2str(preEEG.trials),' ',num2str(postEEG.trials)]);
  disp(['Subj ',num2str(subj_i),' ',num2str(sum(sum(sum(preEEG.data-postEEG.data))))]);
  catch
    continue
  end
end