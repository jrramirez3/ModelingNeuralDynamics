clear; clf;

% This is very similar to the code in HH_F_I_CURVE. See there for 
% more extensive comments. 

tic 
    
c=1;
g_k=80; 
g_na=100;
g_l=0.1;
v_k=-100;
v_na=50;
v_l=-67;

g_h=1;
v_h=-32.9;

i_ext_low=-3.2; i_ext_high=-3.185; 
i_ext_vec=i_ext_low+[0:30]/30*(i_ext_high-i_ext_low);   % external drives
                                                        % to be considered


dt=0.01; dt05=dt/2;

z=zeros(round(5000/dt)+1,1);    % allocate space for v, m, h, n
v=z; m=z; h=z; n=z; r=z;


i_ext=i_ext_vec(1);

v(1)=-70; 
m(1)=m_inf(v(1));
h(1)=0.7; 
n(1)=0.6; 
r(1)=0.2;

done=0;
num_spikes=0;
N=round(1000/dt);
k=1;

while done==0,
    
    v_inc=(g_na*m(k)^3*h(k)*(v_na-v(k))+ ...
        g_k*n(k)^4*(v_k-v(k))+g_l*(v_l-v(k))+ ...
        g_h*r(k)*(v_h-v(k))+i_ext)/c;
    h_inc=alpha_h(v(k))*(1-h(k))-beta_h(v(k))*h(k);
    n_inc=alpha_n(v(k))*(1-n(k))-beta_n(v(k))*n(k);
    r_inc=(r_inf(v(k))-r(k))/tau_r(v(k));
    
    v_tmp=v(k)+dt05*v_inc;
    m_tmp=m_inf(v_tmp);
    h_tmp=h(k)+dt05*h_inc;
    n_tmp=n(k)+dt05*n_inc;
    r_tmp=r(k)+dt05*r_inc;
    
    v_inc=(g_na*m_tmp^3*h_tmp*(v_na-v_tmp)+ ...
        g_k*n_tmp^4*(v_k-v_tmp)+ ...
        g_h*r_tmp*(v_h-v_tmp)+g_l*(v_l-v_tmp)+i_ext)/c;
    h_inc=alpha_h(v_tmp)*(1-h_tmp)-beta_h(v_tmp)*h_tmp;
    n_inc=alpha_n(v_tmp)*(1-n_tmp)-beta_n(v_tmp)*n_tmp;
    r_inc=(r_inf(v_tmp)-r_tmp)/tau_r(v_tmp);
    
    v(k+1)=v(k)+dt*v_inc;
    m(k+1)=m_inf(v(k+1));
    h(k+1)=h(k)+dt*h_inc;
    n(k+1)=n(k)+dt*n_inc;
    r(k+1)=r(k)+dt*r_inc;
    
    if mod(k-1,N)==0 & k>1,
        maxv=max(v(k-N+1:k+1));
        minv=min(v(k-N+1:k+1));
        maxm=max(m(k-N+1:k+1));
        minm=min(m(k-N+1:k+1));
        maxh=max(h(k-N+1:k+1));
        minh=min(h(k-N+1:k+1));
        maxn=max(n(k-N+1:k+1));
        minn=min(n(k-N+1:k+1));
        maxr=max(r(k-N+1:k+1));
        minr=min(r(k-N+1:k+1));
        if (maxv-minv)<0.0001*abs(maxv+minv) & ...
           (maxm-minm)<0.0001*abs(maxm+minm) & ...
           (maxh-minh)<0.0001*abs(maxh+minh) & ...
           (maxn-minn)<0.0001*abs(maxn+minn) & ...
           (maxr-minr)<0.0001*abs(maxr+minr),
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
    h(1)=h(k);
    n(1)=n(k);
    r(1)=r(k);

    done=0;
    num_spikes=0;
    k=1;
    while done==0,
    
        v_inc=(g_na*m(k)^3*h(k)*(v_na-v(k))+ ...
            g_k*n(k)^4*(v_k-v(k))+g_l*(v_l-v(k))+ ...
            g_h*r(k)*(v_h-v(k))+i_ext)/c;
        h_inc=alpha_h(v(k))*(1-h(k))-beta_h(v(k))*h(k);
        n_inc=alpha_n(v(k))*(1-n(k))-beta_n(v(k))*n(k);
        r_inc=(r_inf(v(k))-r(k))/tau_r(v(k));

        v_tmp=v(k)+dt05*v_inc;
        m_tmp=m_inf(v_tmp);
        h_tmp=h(k)+dt05*h_inc;
        n_tmp=n(k)+dt05*n_inc;
        r_tmp=r(k)+dt05*r_inc;

        v_inc=(g_na*m_tmp^3*h_tmp*(v_na-v_tmp)+ ...
            g_k*n_tmp^4*(v_k-v_tmp)+ ...
            g_h*r_tmp*(v_h-v_tmp)+g_l*(v_l-v_tmp)+i_ext)/c;
        h_inc=alpha_h(v_tmp)*(1-h_tmp)-beta_h(v_tmp)*h_tmp;
        n_inc=alpha_n(v_tmp)*(1-n_tmp)-beta_n(v_tmp)*n_tmp;
        r_inc=(r_inf(v_tmp)-r_tmp)/tau_r(v_tmp);

        v(k+1)=v(k)+dt*v_inc;
        m(k+1)=m_inf(v(k+1));
        h(k+1)=h(k)+dt*h_inc;
        n(k+1)=n(k)+dt*n_inc;
        r(k+1)=r(k)+dt*r_inc;

        if mod(k-1,N)==0 & k>1,
            maxv=max(v(k-N+1:k+1));
            minv=min(v(k-N+1:k+1));
            maxm=max(m(k-N+1:k+1));
            minm=min(m(k-N+1:k+1));
            maxh=max(h(k-N+1:k+1));
            minh=min(h(k-N+1:k+1));
            maxn=max(n(k-N+1:k+1));
            minn=min(n(k-N+1:k+1));
            maxr=max(r(k-N+1:k+1));
            minr=min(r(k-N+1:k+1));
            if (maxv-minv)<0.0001*abs(maxv+minv) & ...
               (maxm-minm)<0.0001*abs(maxm+minm) & ...
               (maxh-minh)<0.0001*abs(maxh+minh) & ...
               (maxn-minn)<0.0001*abs(maxn+minn) & ...
               (maxr-minr)<0.0001*abs(maxr+minr),
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
    h(1)=h(k);
    n(1)=n(k);
    r(1)=r(k);

    done=0;
    num_spikes=0;
    k=1;
    while done==0,
    
        v_inc=(g_na*m(k)^3*h(k)*(v_na-v(k))+ ...
            g_k*n(k)^4*(v_k-v(k))+g_l*(v_l-v(k))+ ...
            g_h*r(k)*(v_h-v(k))+i_ext)/c;
        h_inc=alpha_h(v(k))*(1-h(k))-beta_h(v(k))*h(k);
        n_inc=alpha_n(v(k))*(1-n(k))-beta_n(v(k))*n(k);
        r_inc=(r_inf(v(k))-r(k))/tau_r(v(k));

        v_tmp=v(k)+dt05*v_inc;
        m_tmp=m_inf(v_tmp);
        h_tmp=h(k)+dt05*h_inc;
        n_tmp=n(k)+dt05*n_inc;
        r_tmp=r(k)+dt05*r_inc;

        v_inc=(g_na*m_tmp^3*h_tmp*(v_na-v_tmp)+ ...
            g_k*n_tmp^4*(v_k-v_tmp)+ ...
            g_h*r_tmp*(v_h-v_tmp)+g_l*(v_l-v_tmp)+i_ext)/c;
        h_inc=alpha_h(v_tmp)*(1-h_tmp)-beta_h(v_tmp)*h_tmp;
        n_inc=alpha_n(v_tmp)*(1-n_tmp)-beta_n(v_tmp)*n_tmp;
        r_inc=(r_inf(v_tmp)-r_tmp)/tau_r(v_tmp);

        v(k+1)=v(k)+dt*v_inc;
        m(k+1)=m_inf(v(k+1));
        h(k+1)=h(k)+dt*h_inc;
        n(k+1)=n(k)+dt*n_inc;
        r(k+1)=r(k)+dt*r_inc;

        if mod(k-1,N)==0 & k>1,
            maxv=max(v(k-N+1:k+1));
            minv=min(v(k-N+1:k+1));
            maxm=max(m(k-N+1:k+1));
            minm=min(m(k-N+1:k+1));
            maxh=max(h(k-N+1:k+1));
            minh=min(h(k-N+1:k+1));
            maxn=max(n(k-N+1:k+1));
            minn=min(n(k-N+1:k+1));
            maxr=max(r(k-N+1:k+1));
            minr=min(r(k-N+1:k+1));
            if (maxv-minv)<0.0001*abs(maxv+minv) & ...
               (maxm-minm)<0.0001*abs(maxm+minm) & ...
               (maxh-minh)<0.0001*abs(maxh+minh) & ...
               (maxn-minn)<0.0001*abs(maxn+minn) & ...
               (maxr-minr)<0.0001*abs(maxr+minr),
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
axis([i_ext_low,i_ext_high,0,max(f_vec)*1.1]);
set(gca,'Fontsize',16);
xlabel('$I$','Fontsize',20);
ylabel('$f$','Fontsize',20);
shg;
hold off;
ind=find(f_vec==0);
ind=max(ind);
I_star=(i_ext_vec(ind)+i_ext_vec(ind+1))/2
I_c



