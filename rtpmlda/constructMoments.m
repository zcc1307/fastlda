function moments = constructMoments(input_args)

trainX = input_args.trainX;
alpha_0 = input_args.alpha_0;
k = input_args.k;
k2 = input_args.k2;
voc = input_args.voc;

trainX = trainX(sum(trainX,2)>=20, :);
[Docs, Vocs] = size(trainX);
V_abs = sum(trainX,2);
mu = zeros(1,Vocs);
for i = 1:Docs
    mu = mu + trainX(i,:) /V_abs(i);
end
mu = mu / Docs;
mu = mu';



% If we are going to write down Pairs matrix explicitly

V_abs_corr1 = V_abs.*(V_abs-1);
Pairs = full((((trainX ./ (V_abs_corr1 * ones(1,Vocs)))' * trainX) / Docs) ...
 - (diag(sum(trainX ./ (V_abs_corr1 * ones(1,Vocs)), 1) ) / Docs)...
 - (alpha_0/(alpha_0+1)* (mu * mu')));
V_abs_corr2 = V_abs_corr1.*(V_abs-2);
1

R = normrnd(0, 1, [Vocs k2]);
PR = Pairs*R;

% Else implicitly: seems much slower in testing..(?)
%PR = zeros(Vocs, k2);
%for i = 1:Docs
%    i
%    PR = PR + (trainX(i,:)' * (trainX(i,:) * R) - diag(trainX(i,:)') * R)/(V_abs(i) * (V_abs(i)-1));
% end
% PR = PR / Docs;
% PR = PR - alpha_0 / (alpha_0 + 1) * (mu * (mu' * R));
2

[U, S, V] = svd(PR);
U = U(:,1:k);

UPU = U' * Pairs * U;
% UPU = zeros(k,k);
% for i = 1:Docs
%     UPU = UPU + ((U' * trainX(i,:)') * (trainX(i,:) * U) - U' * diag(trainX(i,:)') * U ) / (V_abs(i) * (V_abs(i)-1));
% end
% UPU = UPU / Docs;
% UPU = UPU - alpha_0 / (alpha_0 + 1) * (U' * mu) * (mu' * U);

[U2, T, V2] = svd(UPU);

3

% Verifying WPW approximately equals I.
W = U * U2 * diag(sqrt(ones(k,1)./diag(T)));
WPW = W' * Pairs * W;


% WPW = zeros(k,k);
% for i = 1:Docs
%     WPW = WPW + ((W' * trainX(i,:)') * (trainX(i,:) * W) - W' * diag(trainX(i,:)') * W ) / (V_abs(i) * (V_abs(i)-1));
% end
% WPW = WPW / Docs;
% WPW = WPW - alpha_0 / (alpha_0 + 1) * (W' * mu) * (mu' * W);
moments = [];
moments.W = W;
moments.trainX = trainX;
moments.voc = voc;
moments.mu = mu;
moments.WPW = WPW;
moments.Pairs = Pairs;

end


