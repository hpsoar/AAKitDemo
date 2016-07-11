'use strict';

var React = require('react');

import { StyleSheet, View, Text, NavigatorIOS, NativeModules, } from "react-native"; 

var SimpleList = require('./SimpleList');
var SimpleView = require('./SimpleView');
var AANavigator = NativeModules.AANavigator;

var data = [
    'One',
    'Two',
    'Three',
]

class ModalWithNavigator extends React.Component{
    _handleButton() {
      AANavigator.dismissController(null, true, null);
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
                    title: 'Modal with Navigator',
                    component: SimpleList,
                    passProps: {
                        data: data,
                        rowPressed: this._handleRowPress.bind(this)
                    },
                    leftButtonTitle: 'Close',
                    onLeftButtonPress: this._handleButton.bind(this),
                    rightButtonTitle: 'OK',
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
