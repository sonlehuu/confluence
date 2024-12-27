FROM openjdk:17-bullseye

ENV CONFLUENCE_HOME=/var/confluence \
    CONFLUENCE_INSTALL=/opt/confluence \
    JVM_MINIMUM_MEMORY=4g \
    JVM_MAXIMUM_MEMORY=16g \
    JVM_CODE_CACHE_ARGS='-XX:InitialCodeCacheSize=2g -XX:ReservedCodeCacheSize=4g' \
    AGENT_PATH=/var/agent \
    AGENT_FILENAME=atlassian-agent.jar \
    LIB_PATH=/confluence/WEB-INF/lib

RUN mkdir -p ${CONFLUENCE_INSTALL} ${CONFLUENCE_HOME} ${AGENT_PATH} ${CONFLUENCE_INSTALL}${LIB_PATH} \
&& curl -o ${AGENT_PATH}/${AGENT_FILENAME}  https://github.com/haxqer/confluence/releases/download/v${AGENT_VERSION}/atlassian-agent.jar -L \
&& curl -o /tmp/atlassian.tar.gz https://product-downloads.atlassian.com/software/confluence/downloads/atlassian-${APP_NAME}-${APP_VERSION}.tar.gz -L \
&& tar xzf /tmp/atlassian.tar.gz -C /opt/confluence/ --strip-components 1 \
&& rm -f /tmp/atlassian.tar.gz \
&& curl -o ${CONFLUENCE_INSTALL}/lib/ojdbc8-${ORACLE_DRIVER_VERSION}.jar https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc8/${ORACLE_DRIVER_VERSION}/ojdbc8-${ORACLE_DRIVER_VERSION}.jar -L \
&& cp ${CONFLUENCE_INSTALL}/lib/ojdbc8-${ORACLE_DRIVER_VERSION}.jar ${CONFLUENCE_INSTALL}${LIB_PATH}/ojdbc8-${ORACLE_DRIVER_VERSION}.jar \
&& echo "confluence.home = ${CONFLUENCE_HOME}" > ${CONFLUENCE_INSTALL}/${ATLASSIAN_PRODUCTION}/WEB-INF/classes/confluence-init.properties

# RUN sed -i 's|<property name="confluence.word.import.maxsize">.*</property>|<property name="confluence.word.import.maxsize">209715200</property>|' /var/confluence/confluence.cfg.xml

WORKDIR $CONFLUENCE_INSTALL
EXPOSE 8090

ENTRYPOINT ["/opt/confluence/bin/start-confluence.sh", "-fg"]
