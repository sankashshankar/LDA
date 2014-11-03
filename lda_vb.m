load 20news_w100;
clear groupnames newsgroups;
[V,M] = size(documents);
z = zeros(M,V);
w = zeros(M,V);

K=10;

theta = zeros(M,K);
phi =  zeros(K, V);

beta = 0.5;
alpha = 0.5;


n_m_k = zeros(M,K);
n_z_t = zeros(K,V);

n_m = sum(n_m_k,2);
n_z = sum(n_z_t,2);

N = sum(documents ~= 0);
mult_z = makedist('Multinomial', 'probabilities', ones(1,K)./K);


for m=1:M
    for n=1:V
        if documents(n,m) ~= 0
            k = mult_z.random(1);
            z(m,n) = k;
            n_m_k(m,k)=n_m_k(m,k)+1;
            n_m(m)=n_m(m)+1;
            n_z_t(k,n) = n_z_t(k,n) + 1;
            n_z(k) = n_z(k)+1;
        end
    end
end


phi = 1/K * ones(V,K);
gamma = (alpha + N/K) * ones(1,K);

for n = 1:N
    for i = 1:K
        if documents(n,1) ~= 0
            phi(n,i) = beta * exp(psi(gamma(i)));
        end
    end
    gamma = alpha + sum(phi , 2);
end











