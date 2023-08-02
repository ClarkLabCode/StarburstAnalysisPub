function [resp_reorganize, epoch_ID_new, data_info] = T4T5_OrganizeRespInit(resp, data_info, epoch_ID)

epoch_index = data_info.epoch_index;
param_card = size(epoch_index);
n_param = length(param_card);
n_cell = length(resp);
resp_reorganize = cell(n_cell, 1);

for ii = 1:1:n_cell
    r_s = size(resp{ii});
    if length(r_s) == 3
        r_s = [r_s, 1];
    end
    resp_reshape = zeros([r_s(1), r_s(2), param_card, r_s(4)]);
    epoch_ID_reshape = zeros(param_card);

    if n_param == 4
        for xx = 1:1:param_card(1)
            for yy = 1:1:param_card(2)
                for kk = 1:1:param_card(3)
                    for zz = 1:1:param_card(4)
                        resp_reshape(:,:,xx,yy,kk,zz,:) = resp{ii}(:,:,epoch_index(xx, yy, kk, zz), :);
                        epoch_ID_reshape(xx, yy, kk, zz) = epoch_ID(epoch_index(xx, yy, kk, zz));
                    end
                end
            end
        end
    end

    if n_param == 3
        for xx = 1:1:param_card(1)
            for yy = 1:1:param_card(2)
                for kk = 1:1:param_card(3)
                        resp_reshape(:,:,xx,yy,kk,:) = resp{ii}(:,:,epoch_index(xx, yy, kk), :);
                        epoch_ID_reshape(xx, yy, kk) = epoch_ID(epoch_index(xx, yy, kk));
                end
            end
        end
    end

    if n_param == 2
        for xx = 1:1:param_card(1)
            for yy = 1:1:param_card(2)
                resp_reshape(:,:,xx,yy,:) = resp{ii}(:,:,epoch_index(xx, yy), :);
                epoch_ID_reshape(xx, yy) = epoch_ID(epoch_index(xx, yy));
            end
        end
    end

    resp_reorganize{ii} = reshape(resp_reshape, [r_s(1), r_s(2), prod(param_card), r_s(4)]);
end
data_info.epoch_index = reshape(1:prod(param_card), param_card);
epoch_ID_new =  epoch_ID_reshape(:);
end