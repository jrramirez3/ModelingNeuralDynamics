function g=g(t);

global alpha Period g_bar denom;

g=g_bar*(exp(alpha*cos(pi*t/Period).^2)-1)/denom;