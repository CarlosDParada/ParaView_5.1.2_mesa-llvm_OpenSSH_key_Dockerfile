# This Dockerfile creates a Docker image of "ParaView_5.1.2 with OpenGL and OSMesa using llvmpipe, X Window System, OpenSSH, MPICH, Python and FFmpeg".
# It installs MPICH, GCC, GCC-C++, Make, Git, Python, OpenGL and OSMesa using llvmpipe, OpenGLU, X Window System, OpenSSH, CMake, FFmpeg, ParaView, submodules of ParaView (VTK, IceT, etc.).

# FROM ishidakazuya/paraview_5.1.2_mesa-llvm
FROM ishidakazuya/paraview_5.1.2_mesa-llvm:latest

# MAINTAINER is ishidakauya
MAINTAINER ishidakazuya

# Update
RUN yum -y update

# Install OpenSSH
RUN yum -y install openssh openssh-server openssh-clients

# Configure sshd
RUN mkdir /var/run/sshd

RUN sed -i -e s/\#PermitRootLogin\ yes/PermitRootLogin\ yes/ /etc/ssh/sshd_config
RUN sed -i -e s/\#RSAAuthentication\ yes/RSAAuthentication\ yes/ /etc/ssh/sshd_config
RUN sed -i -e s/\#PubkeyAuthentication\ yes/PubkeyAuthentication\ yes/ /etc/ssh/sshd_config
RUN sed -i -e s/PasswordAuthentication\ yes/\PasswordAuthentication\ no/ /etc/ssh/sshd_config

RUN sed -i -e s@HostKey\ /etc/ssh/ssh_host_dsa_key@\#HostKey\ /etc/ssh/ssh_host_dsa_key@ /etc/ssh/sshd_config
RUN sed -i -e s@HostKey\ /etc/ssh/ssh_host_ecdsa_key@\#HostKey\ /etc/ssh/ssh_host_ecdsa_key@ /etc/ssh/sshd_config
RUN sed -i -e s@HostKey\ /etc/ssh/ssh_host_ed25519_key@\#HostKey\ /etc/ssh/ssh_host_ed25519_key@ /etc/ssh/sshd_config
RUN ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key

RUN mkdir /root/.ssh
RUN ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
RUN mv /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN cat StrictHostKeyChecking=no > /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chmod 700 /root/.ssh

# Use port 11111
EXPOSE 11111

# ENTRYPOINT is /usr/sbin/sshd
ENTRYPOINT /usr/sbin/sshd && tail -f /dev/null
