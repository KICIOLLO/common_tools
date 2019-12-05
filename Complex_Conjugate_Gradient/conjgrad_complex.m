function [X_real,X_imag,err] = conjgrad_complex(A,B,X0,tol,max_iter)
% The algorithm CSYM refers on 
%    Bunse-Gerstner and Stöver, 1999
%    On a conjugate gradient-type method for solving complex symmetric linear systems: 
%    Linear Algebra and its Applications, 287, no. 1, 105-123, 
%    doi: https://doi.org/10.1016/S0024-3795(98)10091-5.

    % Initialize
    r_0 = complex(B - A*X0);
    for jj = 1:length(r_0)
        q_0(jj,1) = complex(0,0);
        p_m1(jj,1) = complex(0,0);
        p_0(jj,1) = complex(0,0);
    end
    q_1 = complex(conj(r_0)/(sqrt(r_0'*r_0)));

    alpha_1 = complex(q_1.'*A*q_1);
    beta_1 = complex(0);
    c_m1 = complex(0);
    s_m1 = complex(0);
    c_0  = complex(1);
    s_0  = complex(0);
    tao_1 = complex(sqrt(r_0'*r_0));

    m = length(B);

    if max_iter <= 0
        max_iter = m;
    end
    
    err = zeros(m,1);
    for ii = 1:max_iter
        phi_1 = complex(c_m1*c_0*beta_1 + conj(s_0)*alpha_1);
        theta_1 = complex(conj(s_m1)*beta_1);
        gamma_1 = complex(c_0*alpha_1 - c_m1*s_0*beta_1);
        www = complex(A*q_1 - alpha_1*conj(q_1) - beta_1*conj(q_0));
        beta_2 = complex(sqrt(www'*www));

        if beta_2 == 0
            break;
        end

        q_2 = complex(conj(www)/beta_2);
        alpha_2 = complex(q_2.'*A*q_2);

        if gamma_1 ~= 0
            tmp_gammabeta = complex(sqrt(abs(gamma_1)*abs(gamma_1) + beta_2*beta_2));
            c_1 = complex(abs(gamma_1)/tmp_gammabeta);
            s_1 = complex(conj(gamma_1)*beta_2/abs(gamma_1)/tmp_gammabeta);
            cauchy_1 = complex(gamma_1*tmp_gammabeta/abs(gamma_1));
        else
            c_1 = complex(0);
            s_1 = complex(1);
            cauchy_1 = complex(beta_2);
        end

        p_1 = complex((q_1 - phi_1*p_0 - theta_1*p_m1)/cauchy_1);
        
        X1 = complex(X0 + tao_1*c_1*p_1);

        tao_2 = complex((-1)*s_1*tao_1);

        err(ii,1) = abs(tao_2);

        c_m1 = complex(c_0);
        c_0  = complex(c_1);
        s_m1 = complex(s_0);
        s_0  = complex(s_1);

        alpha_1 = complex(alpha_2);
        beta_1  = complex(beta_2);
        tao_1   = complex(tao_2);
        X0 = complex(X1);

        q_0 = complex(q_1);
        q_1 = complex(q_2);

        p_m1 = complex(p_0);
        p_0  = complex(p_1);

        if err(ii,1) < tol
            break;
        end
    end

    X_real = real(X0);
    X_imag = imag(X0);

end