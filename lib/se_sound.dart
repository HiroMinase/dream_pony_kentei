import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'dart:io';

enum SeSoundIds {
  correct,
  incorrect,
}

class SeSound {
  String os = Platform.operatingSystem;
  bool isIOS = Platform.isIOS;
  late Soundpool _soundPool;

  final Map<SeSoundIds, int> _seContainer = <SeSoundIds, int>{};
  final Map<int, int> _streamContainer = <int, int>{};

  SeSound() {
    // インスタンス生成
    _soundPool = Soundpool.fromOptions(options: const SoundpoolOptions(
        streamType: StreamType.music,
        maxStreams: 2
    ));
        () async {
      // 読み込んだ効果音をバッファに保持
      var correctSe = await rootBundle.load("assets/se/correct.mp3").then((value) => _soundPool.load(value));
      var incorrectSe = await rootBundle.load("assets/se/incorrect.mp3").then((value) => _soundPool.load(value));
      // バッファに保持した効果音のIDを以下のコンテナに入れておく
      _seContainer[SeSoundIds.correct] = correctSe;
      _seContainer[SeSoundIds.incorrect] = incorrectSe;
      // 効果音を鳴らしたときに保持するためのstreamIdのコンテナを初期化
      // 対象の効果音を強制的に停止する際に使用する
      _streamContainer[correctSe] = 0;
      _streamContainer[incorrectSe] = 0;
    }();
  }

  // 効果音を鳴らすときに本メソッドをEnum属性のSeSoundIdsを引数として実行する
  void playSe(SeSoundIds ids) async {
    // 効果音のIDを取得
    var seId = _seContainer[ids];
    if (seId != null) {
      // 効果音として存在していたら、以降を実施
      // streamIdを取得
      var streamId = _streamContainer[seId] ?? 0;
      if (streamId > 0 && isIOS) {
        // streamIdが存在し、かつOSがiOSだった場合、再生中の効果音を強制的に停止させる
        // iOSの場合、再生中は再度の効果音再生に対応していないため、ボタン連打しても再生されないため
        await _soundPool.stop(streamId);
      }
      // 効果音のIDをplayメソッドに渡して再生処理を実施
      // 再生処理の戻り値をstreamIdのコンテナに設定する
      _streamContainer[seId] = await _soundPool.play(seId);
    } else {
      print("se resource not found! ids: $ids");
    }
  }

  Future<void> dispose() async {
    // 終了時の後始末処理
    await _soundPool.release();
    _soundPool.dispose();
    return;
  }
}