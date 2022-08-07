function output = ExtremaDetector(DOG_space, jmax)
    
    extr_space =cell(9,1);
    extrema =[];
    for i=0:2
        [h,w]=size(DOG_space{((i)*jmax)+1});
        for j=2:(jmax-1)
            B=DOG_space{((i)*jmax)+(j-1)};
            A=DOG_space{(i*jmax)+j};
            C=DOG_space{((i)*jmax)+(j+1)};
            
            ie=0;
             
            for ip=2:(h-1) 
                for jp=2:(w-1)
                    B_sub=B((ip-1):(ip+1),(jp-1):(jp+1));
                    A_sub=A((ip-1):(ip+1),(jp-1):(jp+1));
                    C_sub=C((ip-1):(ip+1),(jp-1):(jp+1));
                    point=A_sub(2,2);
                    
                    BSmax=0; ASmax=0;CSmax=0;BCmax=0;maxValue=0;
                    BSmax=max(max(B_sub));ASmax=max(max(A_sub));CSmax=max(max(C_sub));
                    BCmax=max(BSmax,CSmax);
                    maxValue=max(ASmax,BCmax);
                    
                    BSmin=0; ASmin=0;CSmin=0;BCmin=0;minValue=0;
                    BSmin=min(min(B_sub));ASmin=min(min(A_sub));CSmin=min(min(C_sub));
                    BCmin=min(BSmin,CSmin);
                    minValue=min(ASmin,BCmin);
                    
                    if(point == maxValue) | (point == minValue)
                        ie=ie+1;
                        extrema(ie,1)=ip;%ip*2^i;
                        extrema(ie,2)=jp;%jp*2^i;

                    end
                end
                
            end
            extr_space{((i)*(jmax-2))+(j-1)} = extrema;
            extrema =[];
        end
    end
    output = extr_space;
end