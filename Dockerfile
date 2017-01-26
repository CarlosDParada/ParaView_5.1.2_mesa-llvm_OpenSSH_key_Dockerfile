# This Dockerfile creates an image of "ParaView_5.1.2 with OpenGL and OSMesa using llvmpipe, X Window System, OpenSSH, MPICH, Python and FFmpeg".

# FROM ishidakazuya/paraview_5.1.2_mesa-llvm
FROM ishidakazuya/paraview_5.1.2_mesa-llvm:latest

# MAINTAINER is ishidakauya
MAINTAINER ishidakazuya

# Configure sshd
RUN yum -y update \
&& yum -y install openssh openssh-server openssh-clients bind-utils \
&& yum clean all \
&& mkdir /var/run/sshd \
&& sed -i -e s/\#PermitRootLogin\ yes/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
&& sed -i -e s/\#RSAAuthentication\ yes/RSAAuthentication\ yes/ /etc/ssh/sshd_config \
&& sed -i -e s/\#PubkeyAuthentication\ yes/PubkeyAuthentication\ yes/ /etc/ssh/sshd_config \
&& sed -i -e s/PasswordAuthentication\ yes/\PasswordAuthentication\ no/ /etc/ssh/sshd_config \
&& sed -i -e s@HostKey\ /etc/ssh/ssh_host_dsa_key@\#HostKey\ /etc/ssh/ssh_host_dsa_key@ /etc/ssh/sshd_config \
&& sed -i -e s@HostKey\ /etc/ssh/ssh_host_ecdsa_key@\#HostKey\ /etc/ssh/ssh_host_ecdsa_key@ /etc/ssh/sshd_config \
&& sed -i -e s@HostKey\ /etc/ssh/ssh_host_ed25519_key@\#HostKey\ /etc/ssh/ssh_host_ed25519_key@ /etc/ssh/sshd_config \
&& ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key \
&& mkdir /root/.ssh \
&& ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa \
&& mv /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \
&& chmod 600 /root/.ssh/authorized_keys \
&& echo StrictHostKeyChecking=no > /root/.ssh/config \
&& chmod 600 /root/.ssh/config \
&& chmod 700 /root/.ssh

# Use port 11111
EXPOSE 11111

# ENTRYPOINT is /usr/sbin/sshd
ENTRYPOINT /usr/sbin/sshd && tail -f /dev/null

