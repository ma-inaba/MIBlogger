//
//  APIManager.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/10.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

static NSString *const kKeychainItemName = @"GOAuthTest";
static NSString *const scope = @"https://www.googleapis.com/auth/blogger";// Blogger APIを利用する場合のscope
static NSString *const clientId = @"700198385019-ao59nlenftr2cq3ltqherll23ps7ftnt.apps.googleusercontent.com";// 発行されたClient IDを設定
static NSString *const clientSecret = @"rnKJL41TAcTOt7PfBNTPlUu7";// 発行されたClient Secretを設定
static NSString *const hasLoggedIn = @"hasLoggedInKey";// NSUserDefaultに保存するための文字列


// OAuth認証の開始
- (void)startLogin:(BOOL)logout
{
    // 既に認証をしたかどうか確認
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasLoggedin = [defaults boolForKey:hasLoggedIn];
    if (logout) {
        // 認証したことがない場合
        ModelManager *modelManager = [ModelManager sharedInstance];
        modelManager.blogSummaryModel.oAuth2ViewCon = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope
                                                                                                 clientID:clientId
                                                                                             clientSecret:clientSecret
                                                                                         keychainItemName:kKeychainItemName
                                                                                                 delegate:self
                                                                                         finishedSelector:@selector(viewController:finishedWithAuth:error:)
                                                       ];
        return;
    }
    if(hasLoggedin == YES) {
        // 認証したことがある場合
        self.auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                          clientID:clientId
                                                                      clientSecret:clientSecret];
        // アクセストークンの取得
        [self authorizeRequest];
    } else {
        // 認証したことがない場合
        ModelManager *modelManager = [ModelManager sharedInstance];
        modelManager.blogSummaryModel.oAuth2ViewCon = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope
                                                                                                 clientID:clientId
                                                                                             clientSecret:clientSecret
                                                                                         keychainItemName:kKeychainItemName
                                                                                                 delegate:self
                                                                                         finishedSelector:@selector(viewController:finishedWithAuth:error:)
                                                       ];
    }
}

// 認証後に実行する処理
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error
{
    if(error != nil) {
        // 認証失敗
    } else {
        // 認証成功
        self.auth = auth;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:hasLoggedIn];
        [defaults synchronize];
        
        // アクセストークンの取得
        [self authorizeRequest];
    }
    
    // 認証画面を閉じる
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

// アクセストークンの取得処理
- (void)authorizeRequest
{
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:self.auth.tokenURL];
    [self.auth authorizeRequest:req completionHandler:^(NSError *error) {
        ModelManager *modelManager = [ModelManager sharedInstance];
        modelManager.blogSummaryModel.auth = self.auth;
        NSLog(@"%@", self.auth);
    }];
}

// ブログ一覧を表示する
- (void)requestListByUser {
    //NSOperationQueueを使ってマルチスレッドでリクエスト
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        ModelManager *modelManager = [ModelManager sharedInstance];
        
        //リクエスト用のURLを設定
        NSString *url  = [NSString stringWithFormat:@"https://www.googleapis.com/blogger/v3/users/self/blogs"];
        NSDictionary *myBlogsDict = [self requestUtil:url];
        modelManager.blogSummaryModel.myBlogsDict = myBlogsDict;
    }];
}

- (void)requestPagesList:(NSString *)pageToken {
    //NSOperationQueueを使ってマルチスレッドでリクエスト
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        
        //リクエスト用のパラメータを設定
        ModelManager *modelManager = [ModelManager sharedInstance];
        NSDictionary *selectedBlogDict = modelManager.articleSummaryModel.selectedBlogDict;
        NSString *blogID = [selectedBlogDict objectForKey:@"id"];
        NSString *url;
        NSMutableDictionary *blogArticleDict = [[NSMutableDictionary alloc] init];
        if (pageToken) {
            url  = [NSString stringWithFormat:@"https://www.googleapis.com/blogger/v3/blogs/%@/posts?pageToken=%@",blogID,pageToken];
        } else {
            url  = [NSString stringWithFormat:@"https://www.googleapis.com/blogger/v3/blogs/%@/posts",blogID];            
        }
        blogArticleDict = [[self requestUtil:url] mutableCopy];
        
        modelManager.articleSummaryModel.nextPageToken = [blogArticleDict objectForKey:@"nextPageToken"];
        // 次読み込みの場合
        if (pageToken) {
            NSArray *existingArticleArray = modelManager.articleSummaryModel.blogArticleArray;  //既存の配列
            modelManager.articleSummaryModel.blogArticleArray = [existingArticleArray arrayByAddingObjectsFromArray:[blogArticleDict objectForKey:@"items"]];
        } else {
            modelManager.articleSummaryModel.blogArticleArray = [blogArticleDict objectForKey:@"items"];
        }

        NSArray *contents = [self createContentArray:[blogArticleDict objectForKey:@"items"]];
        NSArray *urlArray = [self searchURLFromContents:contents];
        NSArray *imageURLArray = [self createImageURLArray:urlArray];
        // imageURLArrayの中身をblogArticleDictのitemに順番にいれる
        
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [imageURLArray count]; i++) {
            NSString *imageURL = [imageURLArray objectAtIndex:i];
            [imageArray addObject:imageURL];
        }
        
        
        // 次読み込みの場合
        if (pageToken) {
            NSArray *existingThumbNailArray = modelManager.articleSummaryModel.articleThumbnailArray;  //既存の配列
            modelManager.articleSummaryModel.articleThumbnailArray = [existingThumbNailArray arrayByAddingObjectsFromArray:imageArray];
        } else {
            modelManager.articleSummaryModel.articleThumbnailArray = imageArray;
        }
    }];
}

// 取得した記事一覧からcontentのみを取得し配列にして返す
- (NSArray *)createContentArray:(NSDictionary *)items {
    
    NSMutableArray *contentsArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in items) {
        NSString *content = [dict objectForKey:@"content"];
        [contentsArray addObject:content];
    }
    
    return contentsArray;
}

// contentのみが入った配列からURLのみを取得して返す
- (NSArray *)searchURLFromContents:(NSArray *)contents {
    
    NSMutableArray *urlArray = [[NSMutableArray alloc] init];
    
    for (NSString *string in contents) {
        // ここで正規表現を使ってimgを取り出す
        NSString *imgURL = [self extractImgSrcFromHTML:string];
        if (imgURL != nil) {
            [urlArray addObject:imgURL];   // 記事自体に画像が挿入されていたので追加
            continue;
        }
        
        NSRange startRange = [string rangeOfString:@"href=\""];
        // httpの最初
        NSUInteger startPoint;
        if (startRange.location != NSNotFound) {
            startPoint = startRange.location + startRange.length;
        } else {
            [urlArray addObject:@""];   // 配列の数が合わなくなるので@""を入れる
            continue;   // 見つからなかったので次
        }
        
        // 全ての文字列からhttpまでを削除
        NSString *trimString = [string substringFromIndex:startPoint];
        NSRange endRange = [trimString rangeOfString:@"\""];
        // httpの最後
        NSUInteger endPoint;
        if (endRange.location != NSNotFound) {
            endPoint = endRange.location;
        } else {
            [urlArray addObject:@""];   // 配列の数が合わなくなるので@""を入れる
            continue;   // 見つからなかったので次
        }
        
        NSString *url = [trimString substringToIndex:endPoint];
        [urlArray addObject:url];
    }
    
    return urlArray;
}

// htmlからimgタグを抽出して返す
- (NSString *)extractImgSrcFromHTML:(NSString *)html {
    
    NSRegularExpression *regexp01 = [[NSRegularExpression alloc] initWithPattern:@"(<img.*?src=\")(.*?)(\".*?>)" options:0 error:nil];
    NSArray *results = [regexp01 matchesInString:html options:0 range:NSMakeRange(0, html.length)];
    if ([results count] > 0) {
        NSString *imgURL;
            NSTextCheckingResult *result = [results objectAtIndex:0];
            imgURL = [html substringWithRange:[result rangeAtIndex:2]];
        return imgURL;
    }
    return nil;
}

// URLの配列からHTMLを生成し、そこからimgを取り出して配列にいれる。それを返す
- (NSArray *)createImageURLArray:(NSArray *)urlArray {
    
    NSMutableArray *imageURLArray = [[NSMutableArray alloc] init];
    
    for (NSString *url in urlArray) {
        
        // url自体が画像のURLだった場合
        if ([url hasPrefix:@"http"]) {
            if ([url hasSuffix:@"png"] || [url hasSuffix:@"jpg"] || [url hasSuffix:@"jpeg"]) {
                [imageURLArray addObject:url];
                continue;
            }
        }
        
        if ([self wasPopularSiteReturnURL:url] != nil) {
            [imageURLArray addObject:[self wasPopularSiteReturnURL:url]];
            continue;
        }
        
        NSString *html = [HTMLParser parseHTMLFromURL:url];
        if (html == nil) {
            [imageURLArray addObject:@""];
        } else {
            // ここでhtmlからimageを取り出す
            NSString *imageURL = [self createImageURL:html];
            if ([imageURL hasSuffix:@"png"] || [imageURL hasSuffix:@"jpg"] || [imageURL hasSuffix:@"jpeg"]) {
                [imageURLArray addObject:imageURL];
            } else {
                [imageURLArray addObject:@""];
            }
        }
    }
    
    return imageURLArray;
}

// htmlからimageのURLを取り出す
- (NSString *)createImageURL:(NSString *)html {
    
    NSRegularExpression *regexp01 = [[NSRegularExpression alloc] initWithPattern:@"(<img.*?src=\")(.*?)(\".*?>)"
                                                                         options:0
                                                                           error:nil];
    
    NSArray *results = [regexp01 matchesInString:html options:0 range:NSMakeRange(0, html.length)];
    
    for( int i = 0; i < results.count; i++) {
        
        NSTextCheckingResult *result = [results objectAtIndex:i];

        if (result == nil) {
            return @""; //無し
        }
        
        if ([[html substringWithRange:[result rangeAtIndex:2]] hasPrefix:@"http"]){
            NSString *imageURL = [html substringWithRange:[result rangeAtIndex:2]];
            return imageURL;
        }
    }
    
    return @""; // ひとつもhttpから始まる画像がなかったら@""を返す
}

// urlが有名なサイトだった場合は規定の画像を返す
- (NSString *)wasPopularSiteReturnURL:(NSString *)url {
    
    if([url rangeOfString:@"mynavi"].location != NSNotFound){
        return @"http://www.plus-designing.jp/pd_img/logo_mynavi.gif";
    }
    return nil;
}

- (NSDictionary *)requestUtil:(NSString *)url {
    
    ModelManager *modelManager = [ModelManager sharedInstance];
    NSString *accessToken = [modelManager.blogSummaryModel.auth.parameters objectForKey:@"access_token"];
    NSString *token = [NSString stringWithFormat:@"OAuth %@", accessToken];
    //リクエストを生成
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    //同期通信で送信
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error != nil) {
        NSLog(@"%@",error);
        NSLog(@"Error!");
        return nil;
    }
    
    //取得したレスポンスをJSONパース
    NSMutableDictionary *blogArticleDict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    return blogArticleDict;
}

// ラベルのみを抜き取る
- (NSArray *)pullOutOnlyLabel:(NSArray *)array {
    
    NSMutableArray *allLabels = [[NSMutableArray alloc] init];

    for (NSDictionary *item in array) {
        NSArray *labels = [item objectForKey:@"labels"];
        if ([labels count] > 0) {
            for (NSString *label in labels) {
                BOOL isContains = [allLabels containsObject:label];
                if (!isContains) {
                    [allLabels addObject:label];
                }
            }
        }
    }
    return allLabels;
}

- (void)requestLabelList {
    
    //リクエスト用のパラメータを設定
    ModelManager *modelManager = [ModelManager sharedInstance];
    NSDictionary *selectedBlogDict = modelManager.articleSummaryModel.selectedBlogDict;
    NSString *blogID = [selectedBlogDict objectForKey:@"id"];
    NSString *url;
    url  = [NSString stringWithFormat:@"https://www.googleapis.com/blogger/v3/blogs/%@/posts",blogID];
    NSDictionary *blogArticleDict = [self requestUtil:url];
    NSArray *allLabels;
    allLabels = [self pullOutOnlyLabel:[blogArticleDict objectForKey:@"items"]];
    
    NSString *nextPageToken = [blogArticleDict objectForKey:@"nextPageToken"];
    
    while (nextPageToken) {
        //リクエスト用のパラメータを設定
        ModelManager *modelManager = [ModelManager sharedInstance];
        NSDictionary *selectedBlogDict = modelManager.articleSummaryModel.selectedBlogDict;
        NSString *blogID = [selectedBlogDict objectForKey:@"id"];
        NSString *url;
        url  = [NSString stringWithFormat:@"https://www.googleapis.com/blogger/v3/blogs/%@/posts?pageToken=%@",blogID,nextPageToken];
        
        NSDictionary *blogArticleDict = [self requestUtil:url];
        
        allLabels = [allLabels arrayByAddingObjectsFromArray:[self pullOutOnlyLabel:[blogArticleDict objectForKey:@"items"]]];
        
        allLabels = [[NSOrderedSet orderedSetWithArray:allLabels] array];
        nextPageToken = [blogArticleDict objectForKey:@"nextPageToken"];
    }
    
    [GeneralPurposeUtility saveUserDefault:[NSNumber numberWithBool:YES] key:@"Acquired"];  // 取得済みを保存
    
    [GeneralPurposeUtility saveUserDefault:allLabels key:@"AllLabels"];  // 全てのラベルを保持
    modelManager.articleSummaryModel.allLabels = allLabels;
}
@end
