function OBJ = Trim_Objective (V, T, Alpha, delta_e, delta_r, delta_a, pbar, qbar, rbar, alphadot, h)
OBJ = sqrt((BodyAxisForce(T, fG(25), Aero_Force(fCL(Alpha, delta_e), fQ(h, V), 0.8), ...,
        Aero_Force(fCD(Alpha, delta_e), fQ(h, V), 0.8), ...,
        Aero_Force(fCY(0, delta_r), fQ(h, V), 0.8), ...,
        Alpha))^2 + (BodyAxisMoment(Aero_Moment(fCLM(0, delta_a, delta_r, pbar, rbar), fQ(h, V), 0.8, 3), ...,
        Aero_Moment(fCM(Alpha, delta_e, qbar, alphadot), fQ(h, V), 0.8, 0.26881), ...,
        Aero_Moment(fCN(0, delta_a, delta_r, pbar, rbar), fQ(h, V), 0.8, 3)))^2)