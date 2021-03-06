clear; clf;

% This is very similar to the code in HH_F_I_CURVE. See there for 
% more extensive comments. 

c=1;
g_na=20;
g_k=10; 
g_l=8;
v_na=60;
v_k=-90;
v_l=-80;
tau_n=0.15;

i_ext_vec=-4+[0:30]/30*12;



dt=0.002; dt05=dt/2;

z=zeros(round(5000/dt)+1,1);
v=z; m=z; n=z;

i_ext=i_ext_vec(1);

v(1)=-70; 
m(1)=m_inf(v(1));
n(1)=0.6; 

done=0;
num_spikes=0;
N=round(1000/dt);
k=1;

while done==0,
    
    v_inc=(g_na*m(k)*(v_na-v(k))+ ...
        g_k*n(k)*(v_k-v(k))+g_l*(v_l-v(k))+i_ext)/c;
    n_inc=(n_inf(v(k))-n(k))/tau_n;
    
    v_tmp=v(k)+dt05*v_inc;
    m_tmp=m_inf(v_tmp);
    n_tmp=n(k)+dt05*n_inc;
    
    v_inc=(g_na*m_tmp*(v_na-v_tmp)+ ...
        g_k*n_tmp*(v_k-v_tmp)+g_l*(v_l-v_tmp)+i_ext)/c;
    n_inc=(n_inf(v_tmp)-n_tmp)/tau_n;
    
    v(k+1)=v(k)+dt*v_inc;
    m(k+1)=m_inf(v(k+1));
    n(k+1)=n(k)+dt*n_inc;
    
    if mod(k-1,N)==0 & k>1,
        maxv=max(v(k-N+1:k+1));
        minv=min(v(k-N+1:k+1));
        maxm=max(m(k-N+1:k+1));
        minm=min(m(k-N+1:k+1));
        maxn=max(n(k-N+1:k+1));
        minn=min(n(k-N+1:k+1));
        if (maxv-minv)<0.0001*abs(maxv+minv) & ...
           (maxm-minm)<0.0001*abs(maxm+minm) & ...
           (maxn-minn)<0.0001*abs(maxn+minn),
            f=0;
            done=1;
        end;
    end;
    
    if v(k+1)<-20 & v(k)>=-20,
        num_spikes=num_spikes+1;
        t_spikes(num_spikes)= ...
            (k*dt*(20+v(k))+(k-1)*dt*(-20-v(k+1)))/(v(k)-v(k+1));
    end;
    
    if num_spikes==4,
        f=1000/(t_spikes(4)-t_spikes(3));
        done=1;
    end;
    k=k+1;
end;


f_vec(1)=f;

for ijk=2:length(i_ext_vec),
    i_ext=i_ext_vec(ijk);

    v(1)=v(k); 
    m(1)=m(k);
    n(1)=n(k);
    done=0;
    num_spikes=0;
    k=1;
    
    while done==0,
    
        v_inc=(g_na*m(k)*(v_na-v(k))+ ...
            g_k*n(k)*(v_k-v(k))+g_l*(v_l-v(k))+i_ext)/c;
        n_inc=(n_inf(v(k))-n(k))/tau_n;

        v_tmp=v(k)+dt05*v_inc;
        m_tmp=m_inf(v_tmp);
        n_tmp=n(k)+dt05*n_inc;

        v_inc=(g_na*m_tmp*(v_na-v_tmp)+ ...
            g_k*n_tmp*(v_k-v_tmp)+g_l*(v_l-v_tmp)+i_ext)/c;
        n_inc=(n_inf(v_tmp)-n_tmp)/tau_n;

        v(k+1)=v(k)+dt*v_inc;
        m(k+1)=m_inf(v(k+1));
        n(k+1)=n(k)+dt*n_inc;

        if mod(k-1,N)==0 & k>1,
            maxv=max(v(k-N+1:k+1));
            minv=min(v(k-N+1:k+1));
            maxm=max(m(k-N+1:k+1));
            minm=min(m(k-N+1:k+1));
            maxn=max(n(k-N+1:k+1));
            minn=min(n(k-N+1:k+1));
            if (maxv-minv)<0.0001*abs(maxv+minv) & ...
               (maxm-minm)<0.0001*abs(maxm+minm) & ...
               (maxn-minn)<0.0001*abs(maxn+minn),
                f=0;
                done=1;
            end;
        end;

        if v(k+1)<-20 & v(k)>=-20,
            num_spikes=num_spikes+1;
            t_spikes(num_spikes)= ...
                (k*dt*(20+v(k))+(k-1)*dt*(-20-v(k+1)))/(v(k)-v(k+1));
        end;

        if num_spikes==4,
            f=1000/(t_spikes(4)-t_spikes(3));
            done=1;
        end;
        k=k+1;
    end;

    f_vec(ijk)=f;
    ijk
end;

subplot(211);
plot(i_ext_vec,f_vec,'.k','Markersize',15);
hold on;


ind=find(f_vec==0);
ind=max(ind);
I_c=(i_ext_vec(ind)+i_ext_vec(ind+1))/2;

f_vec(length(i_ext_vec))=f;
for ijk=length(i_ext_vec)-1:-1:1,
    i_ext=i_ext_vec(ijk);

    v(1)=v(k); 
    m(1)=m(k);
    n(1)=n(k);

    done=0;
    num_spikes=0;
    k=1;
    while done==0,
    
        v_inc=(g_na*m(k)*(v_na-v(k))+ ...
            g_k*n(k)*(v_k-v(k))+g_l*(v_l-v(k))+i_ext)/c;
        n_inc=(n_inf(v(k))-n(k))/tau_n;

        v_tmp=v(k)+dt05*v_inc;
        m_tmp=m_inf(v_tmp);
        n_tmp=n(k)+dt05*n_inc;

        v_inc=(g_na*m_tmp*(v_na-v_tmp)+ ...
            g_k*n_tmp*(v_k-v_tmp)+g_l*(v_l-v_tmp)+i_ext)/c;
        n_inc=(n_inf(v_tmp)-n_tmp)/tau_n;

        v(k+1)=v(k)+dt*v_inc;
        m(k+1)=m_inf(v(k+1));
        n(k+1)=n(k)+dt*n_inc;

        if mod(k-1,N)==0 & k>1,
            maxv=max(v(k-N+1:k+1));
            minv=min(v(k-N+1:k+1));
            maxm=max(m(k-N+1:k+1));
            minm=min(m(k-N+1:k+1));
            maxn=max(n(k-N+1:k+1));
            minn=min(n(k-N+1:k+1));
            if (maxv-minv)<0.0001*abs(maxv+minv) & ...
               (maxm-minm)<0.0001*abs(maxm+minm) & ...
               (maxn-minn)<0.0001*abs(maxn+minn),
                f=0;
                done=1;
            end;
        end;

        if v(k+1)<-20 & v(k)>=-20,
            num_spikes=num_spikes+1;
            t_spikes(num_spikes)= ...
                (k*dt*(20+v(k))+(k-1)*dt*(-20-v(k+1)))/(v(k)-v(k+1));
        end;

        if num_spikes==4,
            f=1000/(t_spikes(4)-t_spikes(3));
            done=1;
        end;
        k=k+1;
    end;
    f_vec(ijk)=f;
    ijk
end;

plot(i_ext_vec,f_vec,'ok','Markersize',10,'Linewidth',1);
set(gca,'Fontsize',16);
xlabel('$I$','Fontsize',20);
ylabel('$f$','Fontsize',20);
axis([-3,7,0,1200]);
shg;

hold off;
ind=find(f_vec==0);
ind=max(ind);
I_star=(i_ext_vec(ind)+i_ext_vec(ind+1))/2;

I_c
I_star