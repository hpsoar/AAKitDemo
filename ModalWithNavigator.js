'use strict';

var React = require('react');

import { StyleSheet, View, Text, NavigatorIOS, NativeModules, } from "react-native"; 

var SimpleList = require('./SimpleList');
var SimpleView = require('./SimpleView');
var RNNavigator = NativeModules.RNNavigator;

var data = [
    'react-native push',
    'Two',
    'Three',
]

console.log(RNNavigator);

class ModalWithNavigator extends React.Component{
    _handleButton() {
      console.log(RNNavigator);
      console.log(RNNavigator.dismissController);
      RNNavigator.pop(true, function() {
        console.log("hello");
      });
    }

    _next() {
      RNNavigator.push({
        title: 'hello',
        component: 'ModalWithNavigator',
        style: {
          hideNavigationBar: true,
          hideNavigationBarAnimated: false,
        }
      }, true, function() { });
    }

    _handleRowPress() {
        this.refs.navigator.push({
            title: 'Simple View',
            component: SimpleView,
        });
    }

    render() {
        return (
            <NavigatorIOS
                ref="navigator"
                style={styles.container}
                initialRoute={{
                    title: 'Navigator',
                    component: SimpleList,
                    passProps: {
                        data: data,
                        rowPressed: this._handleRowPress.bind(this)
                    },
                    leftButtonTitle: 'Close',
                    onLeftButtonPress: this._handleButton.bind(this),
                    rightButtonTitle: 'RNNavigagor.push',
                    onRightButtonPress: this._next.bind(this),
                }}
            />
        );
    }
};

var styles = StyleSheet.create({
    container: {
        flex: 1,
    }
});

module.exports = ModalWithNavigator;
