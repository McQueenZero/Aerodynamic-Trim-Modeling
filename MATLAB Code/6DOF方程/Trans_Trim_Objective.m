function TOBJ = Trans_Trim_Objective(x)
TOBJ = sqrt((BodyAxisForce(x(2), fG(25), Aero_Force(fCL(x(3), x(4)), fQ(x(11), x(1)), 0.8), ...,
        Aero_Force(fCD(x(3), x(4)), fQ(x(11), x(1)), 0.8), ...,
        Aero_Force(fCY(0, x(5)), fQ(x(11), x(1)), 0.8), ...,
        x(3)))^2 + (BodyAxisMoment(Aero_Moment(fCLM(0, x(6), x(5), x(7), x(9)), fQ(x(11), x(1)), 0.8, 3), ...,
        Aero_Moment(fCM(x(3), x(4), x(8), x(10)), fQ(x(11), x(1)), 0.8, 0.26881), ...,
        Aero_Moment(fCN(0, x(6), x(5), x(7), x(9)), fQ(x(11),x(1)), 0.8, 3)))^2)