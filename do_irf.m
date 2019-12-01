
figure(1)
set(gcf,'Position',[500 300 900 600])

cut = 2:60;

subplot(231)
plot(4*rn(cut))
title('$r^n_t$','FontSize',14,'interpreter','latex')
set(gcf,'Name','Responses to natural real rate shock')
hold on

subplot(232)
plot(4*i(cut))
title('$i_t$','FontSize',14,'interpreter','latex')
hold on

subplot(233)
plot(4*pi(cut))
title('$\pi_t$','FontSize',14,'interpreter','latex')
hold on

subplot(234)
plot(4*rr(cut))
title('$r_t$','FontSize',14,'interpreter','latex')
hold on

subplot(235)
plot(y(cut))
title('$y_t$','FontSize',14,'interpreter','latex')
hold on

