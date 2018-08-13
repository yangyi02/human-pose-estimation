function [model traintime] = trainmodel(name, pos, location, idx, neg, PARA)
% This function trains a articulated pose model given positive training
% data with negative images. 
% It takes 3 paramters:
%   K: number of mixtures for each part
%   pa: tree structure for the model
%   sbin: HOG cell size w.r.t. image pixels.

globals;

% Log file for storing training information
% filename = [cachedir name '.log'];
% if exist(filename,'file')
%   delete(filename);
% end
% diary(filename);

% Train part HOG template individually for every cluster / type.
traintime = 0;
for p = 1:size(idx,2)
  filename = [name '_part' num2str(p)];
  try
    load([cachedir filename]);
  catch
    tic;
    model0 = initmodel(pos, PARA.sbin);
    sneg = neg(1:min(length(neg), 100)); % Subset of negatives for faster training.
    models = cell(1, max(idx(:,p)));
    for k = 1:max(idx(:,p))
      spos = pos(idx(:,p) == k); % Subset of positives that contains this type data.
      for n = 1:length(spos)
        spos(n).x1 = spos(n).x1(p);
        spos(n).y1 = spos(n).y1(p);
        spos(n).x2 = spos(n).x2(p);
        spos(n).y2 = spos(n).y2(p);
      end
      models{k} = train(filename, model0, spos, sneg, 1, 1);
    end
    model = mergemodels(models);
    traintime = traintime + toc/60;
    save([cachedir filename], 'model', 'traintime');
  end
end

model = buildmodel(name, pos, location, idx, PARA.parent, PARA.sbin);

% showpositivetemplates(name, model, 'init');

% Train pose model jointly with latent update, but fix part types.
suffix = 'final1';
filename = [name '_' suffix];
try
  load([cachedir filename]);
catch
  tic;
  for n = 1:length(pos)
    pos(n).mix = idx(n,:);
	end
  model = train(filename, model, pos, neg, 0, 1);
  traintime(2) = toc/60;
  save([cachedir filename], 'model', 'traintime');
end

%   showpositivetemplates(name, model, suffix);

% Finally train pose model jointly with latent update for all variables.
% suffix = 'final';
% filename = [name '_' suffix];
% try
%   load([cachedir filename]);
% catch
%   tic;
%   if isfield(pos,'mix')
%     pos = rmfield(pos,'mix');
%   end
%   model = train_spring(filename, model, pos, neg, 0, 1);
%   traintime(4) = toc/60;
%   save([cachedir filename], 'model', 'traintime');
% end
