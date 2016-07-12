'use strict';

import React, { Component } from 'react';
import { StyleSheet, Text, View, TouchableHighlight, NativeModules } from 'react-native';

var RNNavigator = NativeModules.RNNavigator;

var data = [
    '嘀嗒',
    '东东塔器',
    '大鱼',
    "Here",
    "is",
    "an",
    "example",
    "of",
    "passing",
    "data",
    "into",
    "a",
    "React",
    "View",
    "that",
    "is",
    "embedded",
    "in",
    "a",
    "Native",
    "View",
]

class SimpleView extends Component {
  _onPressButton() {
    RNNavigator.present({
      title: 'me, me...',      
      component: 'PassingData',
      passProps: { data: data },
    }, true, function() {}, function() {});
  }
  render() {
    return (
      <View>
        <Text style={styles.red}>just red</Text>
        <Text style={styles.bigblue}>just bigblue</Text>
        <Text style={[styles.bigblue, styles.red]}>bigblue, then red</Text>
        <Text style={[styles.red, styles.bigblue]}>red, then bigblue</Text>
        <TouchableHighlight onPress={this._onPressButton}>
             <Text style={styles.bigblue}>RNNavigator.present</Text>
        </TouchableHighlight>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  bigblue: {
    color: 'blue',
    fontWeight: 'bold',
    fontSize: 30,
  },
  red: {
    color: 'red',
  },
});


module.exports = SimpleView;
