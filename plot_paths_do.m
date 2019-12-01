
figure(1)

cut = [1 40];

subplot(231)
plot(rn_sim)
title('$r^n_t$','FontSize',14,'interpreter','latex')
set(gcf,'Name','Responses to natural real rate shock')
hold on
xlim(cut)

subplot(232)
plot(i_sim)
title('$i_t$','FontSize',14,'interpreter','latex')
hold on
xlim(cut)

subplot(233)
plot(pi_sim)
title('$\pi_t$','FontSize',14,'interpreter','latex')
hold on
xlim(cut)

subplot(235)
plot(x_sim)
title('$y_t$','FontSize',14,'interpreter','latex')
hold on
xlim(cut)

