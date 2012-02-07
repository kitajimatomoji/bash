<?php

    if($argc != 3){
        print "invalid parameter. you need -- php c2dm_register.php (gmail_account) (password)\n";
        return;
    }



    require_once "HTTP/Request.php";

    // 認証を実施しAuth 文字列を返す

    $account  = $argv[1];
    $password = $argv[2];

    $rq = new HTTP_Request("https://www.google.com/accounts/ClientLogin");
    $rq->setMethod(HTTP_REQUEST_METHOD_POST);
    $rq->addPostData("accountType", "HOSTED_OR_GOOGLE");
    // Android側で設定した sender と同じもの
    $rq->addPostData("Email", $account);
    $rq->addPostData("Passwd", $password);
    $rq->addPostData("service", "ac2dm");
    // source は適当に設定する
    $rq->addPostData("source", "bigroom-brmap");
    if (!PEAR::isError($rq->sendRequest())) {
        //print "\n" . $rq->getResponseBody();
    } else {
        print "\nRequest Error!!";
    }

    // 受け取ったBody内にAuthが入っているので取り出す。
    $rval = split("Auth=",$rq->getResponseBody());
    $rvala = split("\n",$rval[1]);
    print "\nGoogleLogin auth=[{$rvala[0]}]\n";
