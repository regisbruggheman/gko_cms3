/**
 * Hash
 *    a jQuery plugin that implements the MooTools's Hash, a brand new native/object.
 *
 * Copyright (c) 2010-2011 Guillaume Coguiec <g.coguiec@gmail.com>
 *
 * Inspired by MooTools (mootools-core, mootools-more) under the same MIT license.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is furnished
 * to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

(function ($, window) {

    if (window.Hash) {
        return;
    }

    var Hash = function (params) {
        params = ($.isFunction(params)) ? { initialize:params} : params;
        var Object = function () {
            var value = (this.initialize) ? this.initialize.apply(this, arguments) : this;
            return value;
        };
        $.extend(Object, this);
        $.extend(Object.prototype, params);
        return Object;
    };

    var Hash = new Hash({
        name:'Hash',
        length:0,
        _internals:[ 'length', '$type' ],

        initialize:function (o) {
            if ('undefined' != typeof o) {
                this.merge(o);
            }
            this.$type = this.name.toLowerCase();
        },

        isHash:function (o) {
            if ('undefined' === typeof o) {
                return false;
            }
            return (this.name.toLowerCase() === o.$type);
        },

        clone:function (o) {
            o = (undefined === o) ? this : o;
            if (!this.isHash(o)) {
                throw new Error('cannot clone a non-' + this.name + ' object.');
            }
            var clone = new Hash();
            for (var key in o) {
                if (this.has(key, o)) {
                    clone[key] = o[key];
                }
            }
            return clone;
        },

        has:function (key, bind) {
            bind = (undefined === bind) ? this : bind;
            if (0 <= $.inArray(key, this._internals)) {
                return false;
            }
            return Object.prototype.hasOwnProperty.call(bind, key);
        },

        each:function (fn, bind) {
            bind = (bind) ? bind : this;
            for (var key in this) {
                if (this.has(key)) {
                    fn.call(bind, key, this[key], this);
                }
            }
        },

        merge:function () {
            var argc = arguments.length, argv = Array.prototype.slice.call(arguments);
            if (0 === argc) {
                return this;
            }
            for (var offset in argv) {
                var o = (this.isHash(argv[offset])) ? argv[offset].clone() : argv[offset];
                for (var key in o) {
                    if (this.has(key, o)) {
                        this[key] = o[key];
                    }
                }
            }
            this._updateLength();
            return this;
        },

        set:function (key, value) {
            if (!this[key] || this.has(key)) {
                this[key] = value;
            }
            this._updateLength();
            return this;
        },

        get:function (key) {
            return (this[key] && this.has(key)) ? this[key] : null;
        },

        erase:function (key) {
            if (this.has(key)) {
                delete this[key];
            }
            this._updateLength();
            return this;
        },

        empty:function () {
            this.each(function (key, value) {
                if (this.has(key)) {
                    delete this[key];
                }
            }, this);
            this.length = 0;
            return this;
        },

        keyOf:function (value) {
            var keys = [];
            for (var key in this) {
                if (this.has(key) && value === this[key]) {
                    keys.push(key);
                }
            }
            return (!keys.length) ? null : ((1 === keys.length) ? keys[0] : keys);
        },

        keys:function () {
            var keys = [];
            for (var key in this) {
                if (this.has(key)) {
                    keys.push(key);
                }
            }
            return keys;
        },

        values:function () {
            var values = [];
            for (var key in this) {
                if (this.has(key)) {
                    values.push(this[key]);
                }
            }
            return values;
        },

        cherrypick:function (deep, deeper) {
            var argc = arguments.length, argv = Array.prototype.slice.call(arguments);
            deep = (undefined === deep) ? false : deep;
            deeper = (undefined === deeper) ? false : deeper;
            if (0 === argc) {
                return this.toObject(false);
            }
            var o = {};
            for (var offset in argv) {
                var key = argv[offset];
                if (this.has(key)) {
                    o[key] = (deep && this.isHash(this[key])) ? this[key].toObject(deeper) : this[key];
                }
            }
            return o;
        },

        contains:function (value) {
            return (null != this.keyOf(value));
        },

        register:function (key, value) {
            if (undefined === this[key]) {
                this[key] = value;
            }
            this._updateLength();
            return this;
        },

        map:function (fn, bind, asObject) {
            var results = {};
            bind = (undefined === bind) ? this : bind;
            asObject = (undefined === asObject) ? false : asObject;
            for (var key in this) {
                if (this.has(key)) {
                    results[key] = fn.call(bind, key, this[key], this);
                }
            }
            return (asObject) ? results : new Hash(results);
        },

        filter:function (fn, bind, asObject) {
            var results = {};
            bind = (undefined === bind) ? this : bind;
            asObject = (undefined === asObject) ? false : asObject;
            for (var key in this) {
                var value = this[key];
                if (this.has(key) && fn.call(bind, key, value, this)) {
                    results[key] = value;
                }
            }
            return (asObject) ? results : new Hash(results);
        },

        toObject:function (deep, deeper, fn) {
            var o = {}, self = this;
            deep = (undefined === deep) ? false : deep;
            deeper = (undefined === deeper) ? false : deeper;
            self = ('function' === typeof fn) ? this.map(fn, this) : self;
            for (var key in self) {
                if (self.has(key)) {
                    o[key] = (deep && self.isHash(self[key])) ? self[key].toObject(deeper) : self[key];
                }
            }
            return o;
        },

        _updateLength:function () {
            var length = 0;
            for (var key in this) {
                length += ((this.has(key)) ? 1 : 0);
            }
            this.length = length;
        },

        toString:function () {
            var results = this.toObject(true, true, function (key, value) {
                if ('object' === typeof value) {
                    return value + '';
                }
                return value;
            });
            if ('undefined' === typeof window.JSON) {
                return results.toString();
            }
            return (JSON.stringify) ? JSON.stringify(results) : results.toString();
        },

        toJSON:function () {
            return this.toString();
        }
    });
    $.extend(window, { Hash:Hash, $H:Hash });
    $.extend($, { isHash:function (o) {
        return new Hash().isHash(o);
    } });

})(jQuery, this);
