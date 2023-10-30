# PredicTalk
<img src="https://github.com/jphacks/NG_2305/assets/78719395/c3160c3a-5101-4182-8e85-7ab3148c5d12">

[こちら](https://youtu.be/Jx81Q2Q_JAw)からデモ動画をご覧いただけます。

## 目次
- [製品の概要](#製品概要)
  - [開発の動機](#開発の動機)
  - [製品の説明](#製品の説明）


## 製品の概要
**会話 × Tech**
初心者以上・ネイティブ未満の英語学習者を対象とした英会話を視覚的に補助するためのアプリ

### 開発の動機
日本人が外国人と英語で会話をする場合，英語をほとんど話せない初心者は翻訳アプリを利用します．  
言いたい日本語を入力すれば適切な英語が出力される上，発音が分からなくても機械音声に頼れるからです．  
ところが，英語がある程度話せるユーザの目線に立ってみると，翻訳アプリは英会話を補助するアプリとして十分な機能を果たしてるとは言えません．  
それは，彼らが持つ
- 基本的な単語や文法は知っているので**できるだけ自力で会話したい**
- けれど，実際に会話すると**単語や文法がスムーズに出てこない**
- でも，翻訳アプリをちらちら見ながら会話するのではなく**相手の表情や仕草を見てコミュニケーションしたい**
- それに，**勉強したのに結局翻訳アプリ頼りなのは歯がゆい**
というジレンマを解消できていないからです．

「しかし、何も見ずに英語をスラスラと話せるほどのスピーキングスキルは持っていない！」、そんな方に向けて私たちはARグラスを通して「会話を導いてくれるアプリ」を作成しました！

### 対象ユーザ
- 初心者以上・ネイティブ未満の英語スキルをもっている方
- 単語・文法の知識があるが、、
    - スムーズに単語や文法が出てこない方
    - 緊張しやすい方
- 翻訳アプリに頼りきりになりたくない！という方


学習をして、知識を身につけたにも関わらず、実際の会話で「あれ?何て言えばいいんだっけ?」という状況は起こりやすく、メンタル的に辛い人も多いと思います。

そんな方々に、おすすめのアプリとなっています！！

### 特長
**自分でコミュニケーションを取ること**を目的としています！
#### 🔇 特徴1:発話を補助しすぎません！
「基本的な語学知識を持っているので、できる限り外国の人と**自分の力でコミュニケーションをしたい**」というニーズに応えるために、発話を補助しすぎないようにしています。
これまで勉強してきた単語や文法を駆使して相手と同じ言語でやり取りできる喜びは、翻訳アプリに頼っていては得られないものでしょう！

#### 👀 特徴2：発話を視覚的に補助します！
相手の表情や仕草を見ることはコミュニケーションにおいて大切です。  
そのため、発話を視覚的に補助するデバイスとしてARグラスを使用することで、相手とのコミュニケーションを妨げることなく発話の補助を達成しています！

#### 💪特長3：速度と精度を両立しています！
単語予測技術を複数試行することで、速度と精度のバランスが最も良いモデルを選び、実装しています！結果として、生成AIのChatGPTで有名なOpenAIが提供しているAPIからGPT-3.5-Turboを選択しました！



### 製品説明（具体的な製品の説明）
会話の続きを予測するiOSアプリ 

<img width="590" alt="スクリーンショット 2023-10-30 4 05 47" src="https://github.com/jphacks/NG_2305/assets/78719395/8db669c8-8221-42f5-b3f7-cdd60c2bebc4">

- アプリを起動して画面をタップすると音声認識が開始されます。
- 自身の話した内容は白色の文字で表示されます。
  
<img width="596" alt="スクリーンショット 2023-10-30 4 04 02" src="https://github.com/jphacks/NG_2305/assets/78719395/18f8ca2f-8d62-4b54-a269-0b932a0f29d6">

- 会話の続きを予測した内容は薄い白色の文字で表示されます。

  ![IMG_7924](https://github.com/jphacks/NG_2305/assets/109562639/35ddd113-a542-46d0-9a0f-c078bbbcd8f7)

- ユーザはARグラスに表示された単語を見ることで，思い出せなかった単語や文法を思い出すことで発話をスムーズに行うことができます。これはXREAL社のairというARグラスを着用している様子です！
  
<img width="1285" alt="スクリーンショット 2023-10-30 4 34 26" src="https://github.com/jphacks/NG_2305/assets/109562639/c99497f8-dbb3-4ae8-a9b1-bd5876359a21">

- ARグラスとIphoneを接続します。ARグラスの着用時には背景が透過され，文章だけが表示されます!

### 他の方法との差別化
音声認識と単語予測、さらにARグラスを組み合わせることで、円滑なコミュニケーションを可能としています！
- 翻訳アプリを介した会話
  - お互いがスマホに向かい合っていると、相手の表情や仕草を見ることができない
  - 毎回スマホを見ながら会話するのは疲れてしまう
  - なんとも言えない違和感がある
- 自分の言いたいことを翻訳アプリに通して出力された文章を発音する
  - 自分の力で会話しているとは言い難く、相手とコミュニケーションしている実感が得られない。
  - スムーズな会話ができない
  - 基本的な語学知識はあるのに翻訳アプリに頼りきりなのはもどかしい

### 解決出来ること
初心者以上・ネイティブ未満の外国語学習者が持っている「**学んだ外国語を利用してコミュニケーションしたい**」という思いを尊重し、「実際の会話で単語や文法がスムーズに出てこない」でも「せっかく勉強したのに翻訳アプリにすべて頼って会話するのはもったいない」というジレンマを解決します！
  
また、ただ単語予測をスマホ画面に表示して補助するのではなく、市販のARグラスに投影する形で表示することでコミュニケーションを円滑にするという新しい視点を提供します！


本アプリでは、**グラスをかけて画面をタップするだけ**で、サービスを提供します！
### 今後の展望
今後の展望としては2つの改善点が挙げられます。  
  
1つ目は、**対話内容に基づく予測単語の精度向上**です。  
スマホやPCの予測変換機能はユーザの入力履歴に基づいて予測の精度が向上します。
本製品もこの技術の考え方を利用して、**現在の対話内容や過去の対話履歴に基づいた予測**をすることで精度を向上することを考えています。
  
2つ目は、**UIやその他の機能を充実させること**です。
UIに時間を割いて開発を行うことができなかったため、現在のアプリではUIが質素なものになっています。
**より凝ったデザインを実装**することで、ユーザが使っていて楽しいアプリにすることを目指したいと思っています。
また、2日間の開発ではARグラスの使用を想定した最低限の機能しか実装することができませんでした。
**アプリ単体でのモード**や、**多言語対応**などといった機能も実装していきたいと考えています。

### 注力したこと（こだわり等）
- **次文予測機能の実装**
    - 初めは、速度を担保するためにMobileBertやGPT2といった言語モデルをデバイス上で動かすことを検討しましたが、MobileBertは精度がGPT2は速度が十分なものではありませんでした。
    - 最終的には、OpenAIのAPIを使ってgpt-3.5-turboを使用することで、精度と速度の双方を担保した実装をすることができました。
- **新たな情報源の導入**
    - 市販のARデバイスで使用できるアプリにしたことで、本製品の目的である**コミュニケーションのスムーズさ**を妨害しないで発話の補助を達成しました。
- **視覚的に邪魔になる情報の削除**
    - 音声認識をスタートするためのタップの判定エリアを画面全体にすることで、話しながらでの操作が可能となっています。
    - 画面には自分が話した内容とその文章の続きしか表示されないので、余計な情報がなく、会話中にも使用しやすいUXを意識しました。

## 開発技術
<img width="971" alt="スクリーンショット 2023-10-30 4 51 16" src="https://github.com/jphacks/NG_2305/assets/109562639/807cb967-b25d-4235-88d1-c94052978d7e">

### 活用した技術
#### API・データ
- OpenAI API(gpt-3.5-turbo)
    - ユーザの話した文章の続きを生成させるために使用
    - 自身の環境で本アプリを動作させる場合には、OpenAIAPIKey.swiftに自身のOpenAI API Keyを入力してください。
```Swift:OpenAIAPIKey.swift
//  OpenAIAPIKey.swift

let API_KEY = "<Input Your API Key Here>"
```

#### フレームワーク・ライブラリ・モジュール
- Speech
    - Swiftの純正フレームワークで、音声処理に関するフレームワークです。
    - ユーザの話した内容を文字に起こすために使用しました。
- CoreML・CoreMLTools
    - CoreMLはSwiftの純正フレームワークで、機械学習モデルをSwift上で使用するためのフレームワークです。
    - CoreMLToolsはPythonライブラリで、PytorchやTensorflowで作られたニューラルネットワークモデルをCoreML形式へ変換するためのツールです。
    - これらのツールはMobileBertとGPT2をCoreML形式へ変換し、iOS端末上で動作させるようにするために使用しました。
- Moya
    - OpenAIのAPIをSwiftを使って叩くために使用しました。

#### デバイス
- XREAL air
    - アプリの出力をユーザの視界内に表示するために使用しました。

### 独自技術
#### ハッカソンで開発した独自機能・技術
* 独自で開発したものの内容をこちらに記載してください
* 特に力を入れた部分をファイルリンク、またはcommit_idを記載してください。

##### 音声認識結果を保存する機能
commit_id: [5674e3c7c945d6a1c6ec8a8ade41fcb9ef19ea1d](https://github.com/jphacks/NG_2305/commit/5674e3c7c945d6a1c6ec8a8ade41fcb9ef19ea1d)

音声認識自体はSpeechフレームワークを用いて実装したのですが、音声認識結果を保存する機能を独自に実装しました。

SFSpeechRecognizerを用いて音声をテキストに起こす際に、Speechフレームワークの仕様により音声認識の途中結果をいくつも出力してしまったり、時間経過により認識された文章が削除されてしまい、認識結果が重複して画面に表示されたり話すのを少しでも止めるとこれまでの認識結果が失われるといった問題がありました。

これらを解決するために、音声認識の途中結果をバッファリングしておき、認識が完了したこと検知したら最終結果を画面に出力したり、時間経過で認識された文章が削除されないように、認識結果を保存しておく機能を実装しました。

#### 製品に取り入れた研究内容（データ・ソフトウェアなど）（※アカデミック部門の場合のみ提出必須）
アカデミック部門ではないため無し






