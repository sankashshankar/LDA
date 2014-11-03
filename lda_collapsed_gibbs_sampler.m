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


for iter=1:100
    iter
for m=1:M
    for n=1:V
        if documents(n,m) ~= 0
            k = z(m,n);
            w = documents(n,m); 
            n_m_k(m,k)=n_m_k(m,k)-1;
            n_m(m) =n_m(m)-1;
            n_z_t(k,n) = n_z_t(k,n)-1;
            n_z(k) = n_z(k)-1;
            
            p = zeros(1,K);
            for topic = 1:K
                 p(topic) = (n_z_t(topic,n) + beta)/( n_z(topic) + V*beta) * ...
					(n_m_k(m,topic) + alpha)/(n_m(m) + K*alpha);
            end
            
%             for topic=2:K
%                p(topic) = p(topic) + p(topic-1); 
%             end
%             
%             u = rand() * p(K);
%             
%             for topic = 1:K
%                 if p(topic) > u 
%                     break;
%                 end
%             end

            mult_update = makedist('Multinomial', 'probabilities', p./norm(p,1));
            topic = mult_update.random(1);
            
            
            n_m_k(m,topic)=n_m_k(m,topic)+1;
            n_m(m)=n_m(m)+1;
            n_z_t(topic,n) = n_z_t(topic,n) + 1;
            n_z(topic) = n_z(topic)+1;
            
            z(m,n) = topic;
        end
        
    end
end

end

for m=1:M
    for k=1:K
        theta(m,k) = (n_m_k(m,k) + alpha)/(n_m(m) + K*alpha);
    end
end

for k=1:K
    for n=1:V
        phi(k,n) = (n_z_t(k,n) + beta)/(n_z(k) + V*beta);
    end
end

%%
[sorted_phi, I] = sort(phi, 2, 'descend');
top5wordsPerTopic = wordlist(I(:, 1:5));



