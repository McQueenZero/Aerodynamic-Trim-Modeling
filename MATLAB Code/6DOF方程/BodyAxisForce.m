function F = BodyAxisForce(T, G, L, D, Y, Alpha)
F = sqrt((T - G * sin(Alpha) - D * cos(Alpha) + L * sin(Alpha))^2 ...,
    + Y^2 ...,
    + (G * cos(Alpha) - D * sin(Alpha) - L * cos(Alpha))^2)