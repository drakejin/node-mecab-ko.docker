FROM node:10.15.3

RUN mkdir -p /opt/mecab

COPY ./mecab-ko-tarball/mecab-0.996-ko-0.9.2.tar.gz /opt/mecab/mecab-0.996-ko-0.9.2.tar.gz
COPY ./mecab-ko-tarball/mecab-ko-dic-2.1.1-20180720.tar.gz /opt/mecab/mecab-ko-dic-2.1.1-20180720.tar.gz


# mecab runtime install
RUN tar zxvf /opt/mecab/mecab-0.996-ko-0.9.2.tar.gz -C /opt/mecab
RUN rm /opt/mecab/mecab-0.996-ko-0.9.2.tar.gz
RUN mv /opt/mecab/mecab-0.996-ko-0.9.2 /opt/mecab/run

WORKDIR /opt/mecab/run
RUN /opt/mecab/run/configure
RUN make
RUN make install

# libmecab.so.2를 찾을 수 없는 에러가 나는 경우, 다음과 같은 명령어를 수행해 주어야 합니다.
RUN ldconfig

# mecab dictionary install
RUN tar zxvf /opt/mecab/mecab-ko-dic-2.1.1-20180720.tar.gz -C /opt/mecab
RUN rm /opt/mecab/mecab-ko-dic-2.1.1-20180720.tar.gz
RUN mv /opt/mecab/mecab-ko-dic-2.1.1-20180720 /opt/mecab/dict

WORKDIR /opt/mecab/dict
RUN /opt/mecab/dict/autogen.sh
RUN /opt/mecab/dict/configure
RUN make
RUN make install

WORKDIR /opt

ENTRYPOINT ["tail", "-f", "/dev/null"]