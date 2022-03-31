function ADM = Aero_Moment(Ci, Q, Sw, s)        %s表示飞机结构参数，计算M时为气动弦长cA，计算LM和N时为展长b
ADM = Ci * Q * Sw * s;