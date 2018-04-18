;
 update syi_user set pwd_code= ('x'||substr(md5(alias_),1,8))::bit(32)::int from  sys_pw89 p  where syi_user.id=p.id_usr;